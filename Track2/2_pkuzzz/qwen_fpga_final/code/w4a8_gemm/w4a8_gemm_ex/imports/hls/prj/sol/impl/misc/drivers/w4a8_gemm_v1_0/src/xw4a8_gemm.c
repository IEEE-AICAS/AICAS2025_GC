// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.2 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xw4a8_gemm.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XW4a8_gemm_CfgInitialize(XW4a8_gemm *InstancePtr, XW4a8_gemm_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XW4a8_gemm_Start(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL) & 0x80;
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XW4a8_gemm_IsDone(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XW4a8_gemm_IsIdle(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XW4a8_gemm_IsReady(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XW4a8_gemm_EnableAutoRestart(XW4a8_gemm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XW4a8_gemm_DisableAutoRestart(XW4a8_gemm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AP_CTRL, 0);
}

void XW4a8_gemm_Set_scalar00(XW4a8_gemm *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR00_DATA, Data);
}

u32 XW4a8_gemm_Get_scalar00(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR00_DATA);
    return Data;
}

void XW4a8_gemm_Set_scalar01(XW4a8_gemm *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR01_DATA, Data);
}

u32 XW4a8_gemm_Get_scalar01(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR01_DATA);
    return Data;
}

void XW4a8_gemm_Set_scalar02(XW4a8_gemm *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR02_DATA, Data);
}

u32 XW4a8_gemm_Get_scalar02(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR02_DATA);
    return Data;
}

void XW4a8_gemm_Set_scalar03(XW4a8_gemm *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR03_DATA, Data);
}

u32 XW4a8_gemm_Get_scalar03(XW4a8_gemm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_SCALAR03_DATA);
    return Data;
}

void XW4a8_gemm_Set_axi00_ptr0(XW4a8_gemm *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI00_PTR0_DATA, (u32)(Data));
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI00_PTR0_DATA + 4, (u32)(Data >> 32));
}

u64 XW4a8_gemm_Get_axi00_ptr0(XW4a8_gemm *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI00_PTR0_DATA);
    Data += (u64)XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI00_PTR0_DATA + 4) << 32;
    return Data;
}

void XW4a8_gemm_Set_axi01_ptr0(XW4a8_gemm *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI01_PTR0_DATA, (u32)(Data));
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI01_PTR0_DATA + 4, (u32)(Data >> 32));
}

u64 XW4a8_gemm_Get_axi01_ptr0(XW4a8_gemm *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI01_PTR0_DATA);
    Data += (u64)XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI01_PTR0_DATA + 4) << 32;
    return Data;
}

void XW4a8_gemm_Set_axi02_ptr0(XW4a8_gemm *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI02_PTR0_DATA, (u32)(Data));
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI02_PTR0_DATA + 4, (u32)(Data >> 32));
}

u64 XW4a8_gemm_Get_axi02_ptr0(XW4a8_gemm *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI02_PTR0_DATA);
    Data += (u64)XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_AXI02_PTR0_DATA + 4) << 32;
    return Data;
}

void XW4a8_gemm_InterruptGlobalEnable(XW4a8_gemm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_GIE, 1);
}

void XW4a8_gemm_InterruptGlobalDisable(XW4a8_gemm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_GIE, 0);
}

void XW4a8_gemm_InterruptEnable(XW4a8_gemm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_IER);
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_IER, Register | Mask);
}

void XW4a8_gemm_InterruptDisable(XW4a8_gemm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_IER);
    XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_IER, Register & (~Mask));
}

void XW4a8_gemm_InterruptClear(XW4a8_gemm *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XW4a8_gemm_WriteReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_ISR, Mask);
}

u32 XW4a8_gemm_InterruptGetEnabled(XW4a8_gemm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_IER);
}

u32 XW4a8_gemm_InterruptGetStatus(XW4a8_gemm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XW4a8_gemm_ReadReg(InstancePtr->Control_BaseAddress, XW4A8_GEMM_CONTROL_ADDR_ISR);
}

