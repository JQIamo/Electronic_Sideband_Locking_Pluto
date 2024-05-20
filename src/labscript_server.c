// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * libiio - AD9361 IIO streaming example
 *
 * Copyright (C) 2014 IABG mbH
 * Author: Michael Feilen <feilen_at_iabg.de>
 **/

#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <signal.h>
#include <stdio.h>
#include <iio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>

/* helper macros */
#define MHZ(x) ((long long)(x*1000000.0 + .5))
#define GHZ(x) ((long long)(x*1000000000.0 + .5))

#define IIO_ENSURE(expr) { \
	if (!(expr)) { \
		(void) fprintf(stderr, "assertion failed (%s:%d)\n", __FILE__, __LINE__); \
		(void) abort(); \
	} \
}


/* IIO structs required for transmitting */
static struct iio_context *ctx   = NULL;
static struct iio_channel *tx0_i = NULL;
static struct iio_channel *tx0_q = NULL;
//static struct iio_buffer  *rxbuf = NULL;
static struct iio_buffer  *txbuf = NULL;





/* RX is input, TX is output */
enum iodev { RX, TX };

/* common RX and TX streaming params */
struct stream_cfg {
	long long bw_hz; // Analog banwidth in Hz
	long long fs_hz; // Baseband sample rate in Hz
	long long lo_hz; // Local oscillator frequency in Hz
	const char* rfport; // Port name
};

/* static scratch mem for strings */
static char tmpstr[64];



static bool stop;

/* cleanup and exit */
static void shutdown(void)
{
	printf("* Destroying context\n");
	if (ctx) { iio_context_destroy(ctx); }
	exit(0);
}

static void handle_sig(int sig)
{
	printf("Waiting for process to finish... Got signal %d\n", sig);
	stop = true;
}

/* check return value of attr_write function */
static void errchk(int v, const char* what) {
	 if (v < 0) { fprintf(stderr, "Error %d writing to channel \"%s\"\nvalue may not be supported.\n", v, what); shutdown(); }
}

/* write attribute: long long int */
static void wr_ch_lli(struct iio_channel *chn, const char* what, long long val)
{
	errchk(iio_channel_attr_write_longlong(chn, what, val), what);
}

/* write attribute: string */
static void wr_ch_str(struct iio_channel *chn, const char* what, const char* str)
{
	errchk(iio_channel_attr_write(chn, what, str), what);
}

/* helper function generating channel names */
static char* get_ch_name(const char* type, int id)
{
	snprintf(tmpstr, sizeof(tmpstr), "%s%d", type, id);
	return tmpstr;
}

/* returns ad9361 phy device */
static struct iio_device* get_ad9361_phy(void)
{
	struct iio_device *dev =  iio_context_find_device(ctx, "ad9361-phy");
	IIO_ENSURE(dev && "No ad9361-phy found");
	return dev;
}

/* finds AD9361 streaming IIO devices */
static bool get_ad9361_stream_dev(enum iodev d, struct iio_device **dev)
{
	switch (d) {
	case TX: *dev = iio_context_find_device(ctx, "cf-ad9361-dds-core-lpc"); return *dev != NULL;
	case RX: *dev = iio_context_find_device(ctx, "cf-ad9361-lpc");  return *dev != NULL;
	default: IIO_ENSURE(0); return false;
	}
}

/* finds AD9361 streaming IIO channels */
static bool get_ad9361_stream_ch(enum iodev d, struct iio_device *dev, int chid, struct iio_channel **chn)
{
	*chn = iio_device_find_channel(dev, get_ch_name("voltage", chid), d == TX);
	if (!*chn)
		*chn = iio_device_find_channel(dev, get_ch_name("altvoltage", chid), d == TX);
	return *chn != NULL;
}



/* finds AD9361 phy IIO configuration channel with id chid */
static bool get_phy_chan(enum iodev d, int chid, struct iio_channel **chn)
{
	switch (d) {
	case RX: *chn = iio_device_find_channel(get_ad9361_phy(), get_ch_name("voltage", chid), false); return *chn != NULL;
	case TX: *chn = iio_device_find_channel(get_ad9361_phy(), get_ch_name("voltage", chid), true);  return *chn != NULL;
	default: IIO_ENSURE(0); return false;
	}
}

/* finds AD9361 local oscillator IIO configuration channels */
static bool get_lo_chan(enum iodev d, struct iio_channel **chn)
{
	switch (d) {
	 // LO chan is always output, i.e. true
	case RX: *chn = iio_device_find_channel(get_ad9361_phy(), get_ch_name("altvoltage", 0), true); return *chn != NULL;
	case TX: *chn = iio_device_find_channel(get_ad9361_phy(), get_ch_name("altvoltage", 1), true); return *chn != NULL;
	default: IIO_ENSURE(0); return false;
	}
}

/* applies streaming configuration through IIO */
bool cfg_ad9361_streaming_ch(struct stream_cfg *cfg, enum iodev type, int chid)
{
	struct iio_channel *chn = NULL;

	// Configure phy and lo channels
	printf("* Acquiring AD9361 phy channel %d\n", chid);
	if (!get_phy_chan(type, chid, &chn)) {	return false; }
	wr_ch_str(chn, "rf_port_select",     cfg->rfport);
	wr_ch_lli(chn, "rf_bandwidth",       cfg->bw_hz);
	wr_ch_lli(chn, "sampling_frequency", cfg->fs_hz);

	// Configure LO channel
	printf("* Acquiring AD9361 %s lo channel\n", type == TX ? "TX" : "RX");
	if (!get_lo_chan(type, &chn)) { return false; }
	wr_ch_lli(chn, "frequency", cfg->lo_hz);
	return true;
}

/* simple configuration and streaming */
/* usage:
 * Default context, assuming local IIO devices, i.e., this script is run on ADALM-Pluto for example
 $./a.out
 * URI context, find out the uri by typing `iio_info -s` at the command line of the host PC
 $./a.out usb:x.x.x
 */

void writeReg(uintptr_t Addr, uint32_t Value)
{
	volatile uint32_t *LocalAddr = (volatile uint32_t *)Addr;
	*LocalAddr = Value;
}



#define BASE_ESB_ADDRESS 0x43C00000
#define MAP_SIZE 65536
#define MAP_MASK (MAP_SIZE - 1)

int main (int argc, char **argv)
{
	int fd;
	off_t dev_base = BASE_ESB_ADDRESS;

	printf("I'm about to open the memory file\n");
	fd = open ("/dev/mem",O_RDWR | O_SYNC);
	printf("File opened, now memory mapping\n");
	// uint32_t * esb_control_reg = mmap(	NULL,
	// 					   			PAGE_SIZE,
	// 								PROT_READ | PROT_WRITE,
	// 								MAP_SHARED,
	// 								fd,
	// 								BASE_ESB_ADDRESS);
	
	if (fd == -1) {
        printf("Can't open /dev/mem.\n");
        exit(0);
    }

	unsigned int page_size = getpagesize();
	printf("Page size is %d",page_size);


	uint32_t * esb_control_reg = (uint32_t *) mmap(NULL, page_size,
												   PROT_READ|PROT_WRITE,
												   MAP_SHARED,
												   fd,
												   dev_base & ~MAP_MASK);
	
	//close(fd);
	
	printf("Memory mapped at address %p.\n", esb_control_reg);

	esb_control_reg[0] = 0x0000FFFF; // In-phase channel amplitude
	esb_control_reg[1] = 0x0000FFFF; // quadrature channel amplitude
	printf("address of esb_control_reg[1] %p.\n", &esb_control_reg[1]); 
	printf("value of esb_control_reg[1] %p.\n", esb_control_reg[1]); 
	esb_control_reg[2] = 0x00100000; // IQ phase difference
	esb_control_reg[3] = 27306666;	 // Modulation frequency
	esb_control_reg[4] = 0x00010000; // Ref. output phase 
	esb_control_reg[5] = 0x0000004F; // Modulation depth multiplier
	

	// Device
	struct iio_device *tx;

	// Listen to ctrl+c and IIO_ENSURE
	signal(SIGINT, handle_sig);

	// TRANSMIT configuratiON
	struct stream_cfg txcfg;


	// TX stream config
	txcfg.bw_hz = MHZ(20); // 20 MHz rf bandwidth
	txcfg.fs_hz = MHZ(61.44);   // 61.44 MS/s tx sample rate
	txcfg.lo_hz = GHZ(1.5); // 1.5 GHz rf frequency
	txcfg.rfport = "A"; // port A (select for rf freq.)

	printf("* Acquiring IIO context\n");
	if (argc == 1) {
		IIO_ENSURE((ctx = iio_create_default_context()) && "No context");
	}
	else if (argc == 2) {
		IIO_ENSURE((ctx = iio_create_context_from_uri(argv[1])) && "No context");
	}
	IIO_ENSURE(iio_context_get_devices_count(ctx) > 0 && "No devices");

	printf("* Acquiring AD9361 streaming devices\n");
	IIO_ENSURE(get_ad9361_stream_dev(TX, &tx) && "No tx dev found");


	printf("* Configuring AD9361 for working\n");
	IIO_ENSURE(cfg_ad9361_streaming_ch(&txcfg, TX, 0) && "TX port 0 not found");

	printf("* Initializing AD9361 IIO streaming channels\n");
	IIO_ENSURE(get_ad9361_stream_ch(TX, tx, 0, &tx0_i) && "TX chan i not found");
	IIO_ENSURE(get_ad9361_stream_ch(TX, tx, 1, &tx0_q) && "TX chan q not found");

	printf("* Enabling IIO streaming channels\n");
	iio_channel_enable(tx0_i);
	iio_channel_enable(tx0_q);

	printf("Creating a cyclic buffer");
	txbuf = iio_device_create_buffer(tx, 16, true);

	if (!txbuf) {
		perror("Could not create TX buffer");
		shutdown();
	}

	ssize_t nbytes_tx;
	char *p_dat, *p_end;
	ptrdiff_t p_inc;
	nbytes_tx = iio_buffer_push(txbuf);

	struct iio_channel *chn = NULL;
	if (!get_lo_chan(TX, &chn)){
		perror("Failed to get channel");
		shutdown();
		}

	struct timespec time1, time2;
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time1);
	unsigned long long New_frequency = 750000000;
	for (int i=0;i<1000; i++){
		wr_ch_lli(chn, "frequency", New_frequency);
		New_frequency = New_frequency + 1000000;
		// printf("YEAH\n");
	}
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time2);
	printf("\nTime per step without delay: %d us\n",(time2.tv_nsec-time1.tv_nsec)/1000000);

	printf("* Starting IO streaming (press CTRL+C to cancel)\n");
	while (!stop)
	{
		
	}

	shutdown();
	if (munmap(dev_base & ~MAP_MASK, page_size) == -1) {
        printf("Can't unmap memory from user space.\n");
        exit(0);
    }


	return 0;
}
