#=================================
#====                         ====
#====   BEGIN MODIFICATION    ====
#====                         ====
#=================================


# Opening the design for modifications
update_compile_order -fileset sources_1
open_bd_design {./pluto.srcs/sources_1/bd/system/system.bd}


# Adding the new code

# Phase generator, serializer, axi control registers.

# the next two commands are mutually exclusive.

# Un-comment next row to use the phase generator dynamically compiled every time from migen.
# add_files -norecurse phase_generator.v

# Uncomment next row to use the statically generated verilog code for the phase generator.
add_files -norecurse ../hdl/phase_generator.v



add_files -norecurse ../hdl/serializer_8_bits.v
add_files -norecurse ../hdl/syntactic_sugar.vh
add_files -norecurse ../hdl/axi_registers.v
add_files -norecurse ../hdl/arbitrary_register.v



update_compile_order -fileset sources_1


# Creating cells linked to source code
create_bd_cell -type module -reference phase_generator phase_generator_0
create_bd_cell -type module -reference serializer_8_bits serializer_8_bits_0
create_bd_cell -type module -reference arbitrary_register arbitrary_register_0

# Adding Xilinx IP
# Adding a clock wizard driven by the l_clk output of the axi_ad9361 module
# Setting the reset to 0
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
endgroup
connect_bd_net [get_bd_pins axi_ad9361/l_clk] [get_bd_pins clk_wiz_0/clk_in1]
startgroup
connect_bd_net [get_bd_pins serializer_8_bits_0/slow_clock] [get_bd_pins axi_ad9361/l_clk]
endgroup


create_bd_port -dir O PDH_output
startgroup
connect_bd_net [get_bd_ports PDH_output] [get_bd_pins serializer_8_bits_0/single_ended_out]
endgroup

connect_bd_net [get_bd_pins serializer_8_bits_0/fast_clock] [get_bd_pins clk_wiz_0/clk_out1]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
endgroup
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins clk_wiz_0/reset]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins phase_generator_0/clr]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins phase_generator_0/sys_rst]
connect_bd_net [get_bd_pins phase_generator_0/sys_clk] [get_bd_pins axi_ad9361/l_clk]
startgroup
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {400} CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.500} CONFIG.CLKOUT1_JITTER {101.114}] [get_bd_cells clk_wiz_0]
endgroup



# Taking care of the connectivity
delete_bd_objs [get_bd_nets tx_fir_interpolator_data_out_0] [get_bd_nets tx_fir_interpolator_data_out_1]
connect_bd_net [get_bd_pins phase_generator_0/i] [get_bd_pins axi_ad9361/dac_data_i0]
connect_bd_net [get_bd_pins phase_generator_0/q] [get_bd_pins axi_ad9361/dac_data_q0]
connect_bd_net [get_bd_pins arbitrary_register_0/i_ampl] [get_bd_pins phase_generator_0/i_amp]
connect_bd_net [get_bd_pins arbitrary_register_0/q_ampl] [get_bd_pins phase_generator_0/q_amp]
connect_bd_net [get_bd_pins arbitrary_register_0/phase_difference] [get_bd_pins phase_generator_0/phase]
connect_bd_net [get_bd_pins arbitrary_register_0/frequency] [get_bd_pins phase_generator_0/f]
connect_bd_net [get_bd_pins arbitrary_register_0/phase_PDH] [get_bd_pins phase_generator_0/phase_PDH]
connect_bd_net [get_bd_pins arbitrary_register_0/multiplier] [get_bd_pins phase_generator_0/multiplier]
connect_bd_net [get_bd_pins serializer_8_bits_0/parallel_input] [get_bd_pins phase_generator_0/pdh_output]
connect_bd_net [get_bd_pins serializer_8_bits_0/rst] [get_bd_pins xlconstant_0/dout]

# taking care of the AXI interface
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/sys_ps7/FCLK_CLK0 (100 MHz)} Clk_slave {/sys_ps7/FCLK_CLK0 (100 MHz)} Clk_xbar {/sys_ps7/FCLK_CLK0 (100 MHz)} Master {/sys_ps7/M_AXI_GP0} Slave {/arbitrary_register_0/s00_axi} intc_ip {/axi_cpu_interconnect} master_apm {0}}  [get_bd_intf_pins arbitrary_register_0/s00_axi]

#Change the default system wrapper
#Setting M12 pin (pl_spi_miso) as PDH_utput

remove_files  ./pluto.srcs/sources_1/imports/hdl/system_wrapper.v
file delete -force ./pluto.srcs/sources_1/imports/hdl/system_wrapper.v
add_files -norecurse ../hdl/system_wrapper.v

# Adding the I/Q offset capability

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0
endgroup
connect_bd_net [get_bd_pins arbitrary_register_0/i_offset] [get_bd_pins c_addsub_0/B]
set_property name i_add [get_bd_cells c_addsub_0]
copy_bd_objs /  [get_bd_cells {i_add}]
set_property name q_add [get_bd_cells i_add1]
set_property location {7 2993 406} [get_bd_cells q_add]
startgroup
set_property -dict [list CONFIG.B_Width.VALUE_SRC USER CONFIG.A_Width.VALUE_SRC USER] [get_bd_cells i_add]
set_property -dict [list CONFIG.Implementation {DSP48} CONFIG.A_Width {16} CONFIG.B_Width {16} CONFIG.Latency {2} CONFIG.CE {false} CONFIG.A_Width {16} CONFIG.B_Width {16} CONFIG.Out_Width {16} CONFIG.Latency {2} CONFIG.B_Value {0000000000000000}] [get_bd_cells i_add]
endgroup
delete_bd_objs [get_bd_cells q_add]
copy_bd_objs /  [get_bd_cells {i_add}]
set_property location {6 2874 248} [get_bd_cells i_add1]
connect_bd_net [get_bd_pins arbitrary_register_0/q_offset] [get_bd_pins i_add1/B]
connect_bd_net [get_bd_pins i_add/CLK] [get_bd_pins axi_ad9361/l_clk]
set_property name q_add [get_bd_cells i_add1]
set_property location {6 2876 144} [get_bd_cells i_add]
delete_bd_objs [get_bd_nets phase_generator_0_q]
delete_bd_objs [get_bd_nets phase_generator_0_i]
connect_bd_net [get_bd_pins phase_generator_0/i] [get_bd_pins i_add/A]
connect_bd_net [get_bd_pins q_add/A] [get_bd_pins phase_generator_0/q]
connect_bd_net [get_bd_pins i_add/S] [get_bd_pins axi_ad9361/dac_data_i0]
startgroup
connect_bd_net [get_bd_pins q_add/S] [get_bd_pins axi_ad9361/dac_data_q0]
endgroup
connect_bd_net [get_bd_pins q_add/CLK] [get_bd_pins axi_ad9361/l_clk]






# Saving the modified design

update_compile_order -fileset sources_1
validate_bd_design
save_bd_design
