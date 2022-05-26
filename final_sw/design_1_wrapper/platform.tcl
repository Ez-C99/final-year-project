# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\ezzie\Desktop\final_presentation_repo\final_sw\design_1_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\ezzie\Desktop\final_presentation_repo\final_sw\design_1_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_1_wrapper}\
-hw {C:\Users\ezzie\Desktop\final_presentation_repo\final_sw\design_1_wrapper.xsa}\
-fsbl-target {psu_cortexa53_0} -out {C:/Users/ezzie/Desktop/final_presentation_repo/final_sw}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_1_wrapper}
platform generate -quick
bsp reload
bsp setlib -name libmetal -ver 2.1
bsp setlib -name xilskey -ver 7.0
bsp setlib -name xilpm -ver 3.2
bsp setlib -name xilflash -ver 4.8
bsp setlib -name xilffs -ver 4.4
bsp setlib -name lwip211 -ver 1.3
bsp write
bsp reload
catch {bsp regenerate}
platform -make-local
