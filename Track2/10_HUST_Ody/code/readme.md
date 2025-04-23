
AICAS competition FPGA hardware accelerator
===========================

This repository contains the source code for the FPGA hardware accelerator used in the AICAS competition.
Contributed by Tong HU htong@hust.edu.cn and ZZW

===========================

## How to use

1. send_to_fpga_board_firmware文件夹包含.bin文件和设备树文件。在运行前，将send_to_fpga_board文件夹中的binary_container_1.bin 、pl.dtb、shell.json文件拷贝到fpga板卡的/lib/firmware/xilinx/(你的app名字)文件夹下。

2. 在fpga板卡上运行以下命令载入设备树和.bin文件：
    sudo xmutil unloadapp
    sudo xmutil loadapp (你的app名字)
 
3.source文件夹下为运行的主程序runq_fpga.cpp 以及kernel文件vmm_acc_kernel.cpp。更改QWEN_HF_PATH，在此目录下运行make,将runq_fpga.cpp编译为.so文件。
        viviado_platform 文件夹为用于生成.xsa的项目文件。
        source/hardware platform中的 vitis_export_archive_platform.zip为从vivado自定义的.xsa 生成的vitis platform项目文件(kv260_custom),可导入至vitis-> hardware platform。  
        vitis_export_archive.platform+application.zip 为platform+application项目文件，可从vitis导入。

4. 更改QWEN_HF_PATH，在主目录下运行make acc_eva，make thpt_eva, make comp_eva执行测试程序
    #由于不同设备路径发生更改，需要先执行第3步生成.so文件，并将.so文件搬移至主目录下再执行第四步。   