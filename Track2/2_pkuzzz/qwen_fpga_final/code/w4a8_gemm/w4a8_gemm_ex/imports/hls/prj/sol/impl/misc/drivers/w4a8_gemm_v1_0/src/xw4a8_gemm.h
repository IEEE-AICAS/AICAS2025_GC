// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.2 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XW4A8_GEMM_H
#define XW4A8_GEMM_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xw4a8_gemm_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XW4a8_gemm_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XW4a8_gemm;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XW4a8_gemm_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XW4a8_gemm_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XW4a8_gemm_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XW4a8_gemm_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XW4a8_gemm_Initialize(XW4a8_gemm *InstancePtr, u16 DeviceId);
XW4a8_gemm_Config* XW4a8_gemm_LookupConfig(u16 DeviceId);
int XW4a8_gemm_CfgInitialize(XW4a8_gemm *InstancePtr, XW4a8_gemm_Config *ConfigPtr);
#else
int XW4a8_gemm_Initialize(XW4a8_gemm *InstancePtr, const char* InstanceName);
int XW4a8_gemm_Release(XW4a8_gemm *InstancePtr);
#endif

void XW4a8_gemm_Start(XW4a8_gemm *InstancePtr);
u32 XW4a8_gemm_IsDone(XW4a8_gemm *InstancePtr);
u32 XW4a8_gemm_IsIdle(XW4a8_gemm *InstancePtr);
u32 XW4a8_gemm_IsReady(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_EnableAutoRestart(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_DisableAutoRestart(XW4a8_gemm *InstancePtr);

void XW4a8_gemm_Set_scalar00(XW4a8_gemm *InstancePtr, u32 Data);
u32 XW4a8_gemm_Get_scalar00(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_scalar01(XW4a8_gemm *InstancePtr, u32 Data);
u32 XW4a8_gemm_Get_scalar01(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_scalar02(XW4a8_gemm *InstancePtr, u32 Data);
u32 XW4a8_gemm_Get_scalar02(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_scalar03(XW4a8_gemm *InstancePtr, u32 Data);
u32 XW4a8_gemm_Get_scalar03(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_axi00_ptr0(XW4a8_gemm *InstancePtr, u64 Data);
u64 XW4a8_gemm_Get_axi00_ptr0(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_axi01_ptr0(XW4a8_gemm *InstancePtr, u64 Data);
u64 XW4a8_gemm_Get_axi01_ptr0(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_Set_axi02_ptr0(XW4a8_gemm *InstancePtr, u64 Data);
u64 XW4a8_gemm_Get_axi02_ptr0(XW4a8_gemm *InstancePtr);

void XW4a8_gemm_InterruptGlobalEnable(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_InterruptGlobalDisable(XW4a8_gemm *InstancePtr);
void XW4a8_gemm_InterruptEnable(XW4a8_gemm *InstancePtr, u32 Mask);
void XW4a8_gemm_InterruptDisable(XW4a8_gemm *InstancePtr, u32 Mask);
void XW4a8_gemm_InterruptClear(XW4a8_gemm *InstancePtr, u32 Mask);
u32 XW4a8_gemm_InterruptGetEnabled(XW4a8_gemm *InstancePtr);
u32 XW4a8_gemm_InterruptGetStatus(XW4a8_gemm *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
