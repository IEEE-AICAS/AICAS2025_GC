// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.2 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xw4a8_gemm.h"

extern XW4a8_gemm_Config XW4a8_gemm_ConfigTable[];

XW4a8_gemm_Config *XW4a8_gemm_LookupConfig(u16 DeviceId) {
	XW4a8_gemm_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XW4A8_GEMM_NUM_INSTANCES; Index++) {
		if (XW4a8_gemm_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XW4a8_gemm_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XW4a8_gemm_Initialize(XW4a8_gemm *InstancePtr, u16 DeviceId) {
	XW4a8_gemm_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XW4a8_gemm_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XW4a8_gemm_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

