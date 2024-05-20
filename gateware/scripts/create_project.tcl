set current_dir [file normalize [file join [file dirname [info script]] "."]]

# First the original Pluto design is loaded
source $current_dir/build_original_pluto_design.tcl



# Then the modifications to implement desired extra functionalities and remove unwanted functions are done
source $current_dir/modify_project.tcl



# Finally the design generates the bitfile that needs to be loaded into ADALM Pluto
source $current_dir/run_project.tcl