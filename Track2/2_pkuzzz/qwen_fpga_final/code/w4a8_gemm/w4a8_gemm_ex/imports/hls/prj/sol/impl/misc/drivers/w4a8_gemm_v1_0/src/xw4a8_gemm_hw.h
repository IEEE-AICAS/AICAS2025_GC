// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.2 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/COR)
//        bit 0 - ap_done (Read/COR)
//        bit 1 - ap_ready (Read/COR)
//        others - reserved
// 0x10 : Data signal of scalar00
//        bit 31~0 - scalar00[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of scalar01
//        bit 31~0 - scalar01[31:0] (Read/Write)
// 0x1c : reserved
// 0x20 : Data signal of scalar02
//        bit 31~0 - scalar02[31:0] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of scalar03
//        bit 31~0 - scalar03[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of axi00_ptr0
//        bit 31~0 - axi00_ptr0[31:0] (Read/Write)
// 0x34 : Data signal of axi00_ptr0
//        bit 31~0 - axi00_ptr0[63:32] (Read/Write)
// 0x38 : reserved
// 0x3c : Data signal of axi01_ptr0
//        bit 31~0 - axi01_ptr0[31:0] (Read/Write)
// 0x40 : Data signal of axi01_ptr0
//        bit 31~0 - axi01_ptr0[63:32] (Read/Write)
// 0x44 : reserved
// 0x48 : Data signal of axi02_ptr0
//        bit 31~0 - axi02_ptr0[31:0] (Read/Write)
// 0x4c : Data signal of axi02_ptr0
//        bit 31~0 - axi02_ptr0[63:32] (Read/Write)
// 0x50 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XW4A8_GEMM_CONTROL_ADDR_AP_CTRL         0x00
#define XW4A8_GEMM_CONTROL_ADDR_GIE             0x04
#define XW4A8_GEMM_CONTROL_ADDR_IER             0x08
#define XW4A8_GEMM_CONTROL_ADDR_ISR             0x0c
#define XW4A8_GEMM_CONTROL_ADDR_SCALAR00_DATA   0x10
#define XW4A8_GEMM_CONTROL_BITS_SCALAR00_DATA   32
#define XW4A8_GEMM_CONTROL_ADDR_SCALAR01_DATA   0x18
#define XW4A8_GEMM_CONTROL_BITS_SCALAR01_DATA   32
#define XW4A8_GEMM_CONTROL_ADDR_SCALAR02_DATA   0x20
#define XW4A8_GEMM_CONTROL_BITS_SCALAR02_DATA   32
#define XW4A8_GEMM_CONTROL_ADDR_SCALAR03_DATA   0x28
#define XW4A8_GEMM_CONTROL_BITS_SCALAR03_DATA   32
#define XW4A8_GEMM_CONTROL_ADDR_AXI00_PTR0_DATA 0x30
#define XW4A8_GEMM_CONTROL_BITS_AXI00_PTR0_DATA 64
#define XW4A8_GEMM_CONTROL_ADDR_AXI01_PTR0_DATA 0x3c
#define XW4A8_GEMM_CONTROL_BITS_AXI01_PTR0_DATA 64
#define XW4A8_GEMM_CONTROL_ADDR_AXI02_PTR0_DATA 0x48
#define XW4A8_GEMM_CONTROL_BITS_AXI02_PTR0_DATA 64

