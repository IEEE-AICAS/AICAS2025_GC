

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "gemv_float_q8" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_CTRL_BASEADDR" "C_S00_AXI_CTRL_HIGHADDR"
}
