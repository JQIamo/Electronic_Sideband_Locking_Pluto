
source ../../hdl/projects/scripts/adi_env.tcl

# environment related stuff

set ad_hdl_dir [file normalize [file join [file dirname [info script]] "../../hdl"]]
set this_proj_dir [file normalize [file join [file dirname [info script]] "../"]]


if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
}

if [info exists ::env(ADI_GHDL_DIR)] {
  set ad_ghdl_dir [file normalize $::env(ADI_GHDL_DIR)]
}

set ad_ghdl_dir [file normalize $ad_hdl_dir/library]


source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7z010clg225-1"
adi_project pluto


# the following imports are from $ad_hdl_dir only in the original Pluto design.

adi_project_files pluto [list \
  "$this_proj_dir/hdl/system_top.v" \
  "$this_proj_dir/constraints/system_constr.xdc" \
  "$this_proj_dir/constraints/false_paths.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

set_property is_enabled false [get_files  *system_sys_ps7_0.xdc]