SYSROOT = ../staging
PKG_CONFIG_PATH=${SYSROOT}/usr/lib/pkgconfig
CC=arm-linux-gnueabihf-gcc
CFLAGS += -mfloat-abi=hard  --sysroot=${SYSROOT} -std=gnu99 -g -o pluto_stream  -lpthread -liio -lm -Wall -Wextra 
LIBS += --sysroot=${SYSROOT}

PLUTO_IP_ADDRESS +=192.168.2.1


all: server

server: labscript_server.c
	${CC} ${CFLAGS} labscript_server.c -o server

deploy:
	sshpass -p analog scp server root@${PLUTO_IP_ADDRESS}:/root 
