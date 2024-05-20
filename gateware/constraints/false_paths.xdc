# The following constraint is set because for the specific application of generating an arbitrary modulation
#  from the content of a series of registers we do not care if the clock governing the registers is in sync with
#  the DDS core.

set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks rx_clk]
