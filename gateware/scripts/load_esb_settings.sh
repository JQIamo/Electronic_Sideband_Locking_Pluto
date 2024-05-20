#!/bin/sh

# This is the memory map for the load_esb mapped memory

# 0x43C0_0000 i_ampl              16 bits
# 0x43C0_0004 q_ampl              16 bits
# 0x43C0_0008 phase_difference    unused 22 bit
# 0x43C0_000C frequency           32 bit
# 0x43C0_0010 phase_PDH           20 bit
# 0x43C0_0014 multiplier           8 bit

#i_ampl
devmem 0x43C00000 32 0x0000FFFF
sleep 0.1

#q_ampl
devmem 0x43C00004 32 0x0000FFFF
sleep 0.1



# frequency
devmem 0x43C0000C 32  59910463
sleep 0.1


#multiplier
devmem 0x43C00014 32 0x000000FF
sleep 0.1



# Phase_PDH
devmem 0x43C00010 32 0x00010000

#phase difference
devmem 0x43C00008 32 0x00100000

              