#==================================================================
# Project            : DMA Design Compiler
# File Nane          : dc.tcl
# Author             : xxl
#==================================================================

#==================================================================
# step 1 : set the environment
#==================================================================
sh rm -rf ./WORK
sh mkdir  ./WORK
define_design_lib WORK -path ./WORK

#==================================================================
# step 2 : read the rtl source code and set the lib
#==================================================================
set_app_var  search_path     "./lib"
set_app_var  target_library  "scc55nll_hd_hvt_ss_v0p81_125c_basic.db";
set_app_var  link_library    "* $target_library dw_foundation.sldb";
set_app_var  symbol_library  scc55nll_hd_hvt.sdb;

read_file -format verilog ./DMA.v
check_design
set TOP_MODULE  DMA
current_design  $TOP_MODULE

#==================================================================
# step 3 : reset the design
#==================================================================
reset_design

#==================================================================
# step 4 : timing and constraint
#==================================================================
create_clock -period 2.5 [get_ports clk]
set_input_delay -max 3 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay -max 2.5 -clock clk [all_outputs]
set_input_transition 0.15 [all_inputs]

#==================================================================
# step 5 : compile
#==================================================================
set_host_options -max_cores 16
compile

#==================================================================
# step 6 : generate the report
#==================================================================
set REPORT_PATH  rpt
redirect   -tee   -file ./${REPORT_PATH}/check_design.txt           {check_design}
redirect   -tee   -file ./${REPORT_PATH}/check_timing.txt           {check_timing}
redirect   -tee   -file ./${REPORT_PATH}/report_constraint.txt      {report_constraint -all_violators -significant_digits 5}
redirect   -tee   -file ./${REPORT_PATH}/check_setup.txt            {report_timing -delay_type  max -significant_digits 5}
redirect   -tee   -file ./${REPORT_PATH}/check_hold.txt             {report_timing -delay_type  min -significant_digits 5}
redirect   -tee   -file ./${REPORT_PATH}/report_timing.txt          {report_timing -transition_time -input_pins -nets -capacitance}
redirect   -tee   -file ./${REPORT_PATH}/report_area.txt            {report_area -hierarchy}
redirect   -tee   -file ./${REPORT_PATH}/case_analysis.txt          {report_case_analysis -all}
redirect   -tee   -file ./${REPORT_PATH}/report_qor.txt             {report_qor}
redirect   -tee   -file ./${REPORT_PATH}/report_power.txt           {report_power -analysis_effort high -verbose}
redirect   -tee   -file ./${REPORT_PATH}/report_timing_loops.txt    {report_timing -loops}
redirect   -tee   -file ./${REPORT_PATH}/high_fanout_after_compile.txt {report_net_fanout -high_fanout}
redirect   -tee   -file ./${REPORT_PATH}/report_auto_ungroup.txt    {report_auto_ungroup}

set_svf -off

# dcprocheck xxx.tcl (check the error in the xxx.tcl)