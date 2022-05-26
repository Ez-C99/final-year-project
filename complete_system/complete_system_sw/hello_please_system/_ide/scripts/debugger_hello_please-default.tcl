# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\ezzie\Desktop\final_presentation_repo\complete_system\complete_system_sw\hello_please_system\_ide\scripts\debugger_hello_please-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\ezzie\Desktop\final_presentation_repo\complete_system\complete_system_sw\hello_please_system\_ide\scripts\debugger_hello_please-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Arty S7 - 50 210352AD6E9CA" && level==0 && jtag_device_ctx=="jsn-Arty S7 - 50-210352AD6E9CA-0362f093-0"}
fpga -file C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/complete_system_sw/hello_please/_ide/bitstream/design_1_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/complete_system_sw/design_1_wrapper/export/design_1_wrapper/hw/design_1_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/complete_system_sw/hello_please/Debug/hello_please.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
