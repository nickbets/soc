#set search_path [list "/home/cxs/" "."]

#set search_path [list "/home/cxs/" "." "TECHLIBS/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/db_nldm/"]

set target_library sg13g2_stdcell_slow_1p35V_125C.db

#set target_library saed14rvt_ss0p6v125c.db
#set symbol_library cdr3.sdb
set link_library [concat  "*" $target_library]

analyze -f verilog mousetrap.v

elaborate mousetrap

current_design mousetrap 

create_clock -name phi1 -period 10 -waveform {0 3} phi1
create_clock -name phi2 -period 10 -waveform {4 7} phi2

all_inputs
all_outputs
all_clocks
all_registers

set_input_delay 0 -clock phi1 [all_inputs]
set_output_delay 0 -clock phi1 [all_outputs]
set_input_delay 0 -clock phi2 [all_inputs]
set_output_delay 0 -clock phi2 [all_outputs]

set_false_path -from reset

compile -map_effort high -exact_map

set_scan_state scan_existing

set_scan_path c0 -view existing_dft \
-scan_data_in [get_ports test_si] \
-scan_data_out [get_ports test_so] \
-scan_enable [get_ports test_se] \
-infer_dft_signals

set test_default_scan_style lssd

set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 40
set test_default_period 100

set_dft_signal -view existing_dft -type ScanMasterClock -port phi1 \
-timing [list 10 40]

set_dft_signal -view existing_dft -type ScanMasterClock -port phi2 \
-timing [list 60 90]

set_dft_signal -view existing_dft -type Reset -port reset \

create_test_protocol -infer_clock \
-infer_asynch

report_constraint -all_violators

dft_drc

set_scan_configuration -chain_count 1

preview_dft 

insert_dft

report_constraint -all_violators

report_scan_path -view existing -chain all 

write_test_protocol -output TEST.SPF

# report_area
# report_timing
# report_power

write_sdf -version 1.0 MOUSETRAP-MAPPED.SDF

write -hierarchy -format verilog -output MOUSETRAP-MAPPED.v

