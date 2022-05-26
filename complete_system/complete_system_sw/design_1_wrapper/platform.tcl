# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\ezzie\Desktop\final_presentation_repo\complete_system\complete_system_sw\design_1_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\ezzie\Desktop\final_presentation_repo\complete_system\complete_system_sw\design_1_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_1_wrapper}\
-hw {C:\Users\ezzie\Desktop\final_presentation_repo\complete_system\design_1_wrapper.xsa}\
-fsbl-target {psu_cortexa53_0} -out {C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/complete_system_sw}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_1_wrapper}
platform generate -quick
platform clean
platform config -updatehw {C:/Users/ezzie/Desktop/microblaze_aes_mihai/design_1_wrapper.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/design_1_wrapper.xsa}
bsp reload
catch {bsp regenerate}
platform config -updatehw {C:/Users/ezzie/Desktop/final_presentation_repo/complete_system/design_1b_wrapper.xsa}
bsp reload
catch {bsp regenerate}
catch {bsp regenerate}
