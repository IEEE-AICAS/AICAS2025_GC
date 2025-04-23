set moduleName Loop_VITIS_LOOP_324_2_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 17
set C_modelName {Loop_VITIS_LOOP_324_2_proc}
set C_modelType { int 1024 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ wide_trip_count int 16 regular {fifo 0}  }
	{ xi int 128 regular {fifo 0}  }
	{ mro0 int 128 regular {fifo 0}  }
	{ mro1 int 128 regular {fifo 0}  }
	{ mro2 int 128 regular {fifo 0}  }
	{ mro3 int 128 regular {fifo 0}  }
	{ p_read float 32 regular  }
	{ p_read2 float 32 regular  }
	{ p_read6 float 32 regular  }
	{ p_read10 float 32 regular  }
	{ p_read14 float 32 regular  }
	{ p_read18 float 32 regular  }
	{ p_read22 float 32 regular  }
	{ p_read26 float 32 regular  }
	{ p_read30 float 32 regular  }
	{ p_read34 float 32 regular  }
	{ p_read38 float 32 regular  }
	{ p_read42 float 32 regular  }
	{ p_read46 float 32 regular  }
	{ p_read50 float 32 regular  }
	{ p_read54 float 32 regular  }
	{ p_read58 float 32 regular  }
	{ p_read62 float 32 regular  }
	{ p_read66 float 32 regular  }
	{ p_read70 float 32 regular  }
	{ p_read74 float 32 regular  }
	{ p_read78 float 32 regular  }
	{ p_read82 float 32 regular  }
	{ p_read86 float 32 regular  }
	{ p_read90 float 32 regular  }
	{ p_read94 float 32 regular  }
	{ p_read98 float 32 regular  }
	{ p_read102 float 32 regular  }
	{ p_read106 float 32 regular  }
	{ p_read110 float 32 regular  }
	{ p_read114 float 32 regular  }
	{ p_read118 float 32 regular  }
	{ p_read122 float 32 regular  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "wide_trip_count", "interface" : "fifo", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "xi", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro0", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro1", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro2", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro3", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read2", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read6", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read10", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read14", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read18", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read22", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read26", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read30", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read34", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read38", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read42", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read46", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read50", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read54", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read58", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read62", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read66", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read70", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read74", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read78", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read82", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read86", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read90", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read94", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read98", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read102", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read106", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read110", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read114", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read118", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read122", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "ap_return", "interface" : "wire", "bitwidth" : 1024} ]}
# RTL Port declarations: 
set portNum 101
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ wide_trip_count_dout sc_in sc_lv 16 signal 0 } 
	{ wide_trip_count_empty_n sc_in sc_logic 1 signal 0 } 
	{ wide_trip_count_read sc_out sc_logic 1 signal 0 } 
	{ wide_trip_count_num_data_valid sc_in sc_lv 3 signal 0 } 
	{ wide_trip_count_fifo_cap sc_in sc_lv 3 signal 0 } 
	{ xi_dout sc_in sc_lv 128 signal 1 } 
	{ xi_empty_n sc_in sc_logic 1 signal 1 } 
	{ xi_read sc_out sc_logic 1 signal 1 } 
	{ xi_num_data_valid sc_in sc_lv 3 signal 1 } 
	{ xi_fifo_cap sc_in sc_lv 3 signal 1 } 
	{ mro0_dout sc_in sc_lv 128 signal 2 } 
	{ mro0_empty_n sc_in sc_logic 1 signal 2 } 
	{ mro0_read sc_out sc_logic 1 signal 2 } 
	{ mro0_num_data_valid sc_in sc_lv 3 signal 2 } 
	{ mro0_fifo_cap sc_in sc_lv 3 signal 2 } 
	{ mro1_dout sc_in sc_lv 128 signal 3 } 
	{ mro1_empty_n sc_in sc_logic 1 signal 3 } 
	{ mro1_read sc_out sc_logic 1 signal 3 } 
	{ mro1_num_data_valid sc_in sc_lv 3 signal 3 } 
	{ mro1_fifo_cap sc_in sc_lv 3 signal 3 } 
	{ mro2_dout sc_in sc_lv 128 signal 4 } 
	{ mro2_empty_n sc_in sc_logic 1 signal 4 } 
	{ mro2_read sc_out sc_logic 1 signal 4 } 
	{ mro2_num_data_valid sc_in sc_lv 3 signal 4 } 
	{ mro2_fifo_cap sc_in sc_lv 3 signal 4 } 
	{ mro3_dout sc_in sc_lv 128 signal 5 } 
	{ mro3_empty_n sc_in sc_logic 1 signal 5 } 
	{ mro3_read sc_out sc_logic 1 signal 5 } 
	{ mro3_num_data_valid sc_in sc_lv 3 signal 5 } 
	{ mro3_fifo_cap sc_in sc_lv 3 signal 5 } 
	{ p_read sc_in sc_lv 32 signal 6 } 
	{ p_read2 sc_in sc_lv 32 signal 7 } 
	{ p_read6 sc_in sc_lv 32 signal 8 } 
	{ p_read10 sc_in sc_lv 32 signal 9 } 
	{ p_read14 sc_in sc_lv 32 signal 10 } 
	{ p_read18 sc_in sc_lv 32 signal 11 } 
	{ p_read22 sc_in sc_lv 32 signal 12 } 
	{ p_read26 sc_in sc_lv 32 signal 13 } 
	{ p_read30 sc_in sc_lv 32 signal 14 } 
	{ p_read34 sc_in sc_lv 32 signal 15 } 
	{ p_read38 sc_in sc_lv 32 signal 16 } 
	{ p_read42 sc_in sc_lv 32 signal 17 } 
	{ p_read46 sc_in sc_lv 32 signal 18 } 
	{ p_read50 sc_in sc_lv 32 signal 19 } 
	{ p_read54 sc_in sc_lv 32 signal 20 } 
	{ p_read58 sc_in sc_lv 32 signal 21 } 
	{ p_read62 sc_in sc_lv 32 signal 22 } 
	{ p_read66 sc_in sc_lv 32 signal 23 } 
	{ p_read70 sc_in sc_lv 32 signal 24 } 
	{ p_read74 sc_in sc_lv 32 signal 25 } 
	{ p_read78 sc_in sc_lv 32 signal 26 } 
	{ p_read82 sc_in sc_lv 32 signal 27 } 
	{ p_read86 sc_in sc_lv 32 signal 28 } 
	{ p_read90 sc_in sc_lv 32 signal 29 } 
	{ p_read94 sc_in sc_lv 32 signal 30 } 
	{ p_read98 sc_in sc_lv 32 signal 31 } 
	{ p_read102 sc_in sc_lv 32 signal 32 } 
	{ p_read106 sc_in sc_lv 32 signal 33 } 
	{ p_read110 sc_in sc_lv 32 signal 34 } 
	{ p_read114 sc_in sc_lv 32 signal 35 } 
	{ p_read118 sc_in sc_lv 32 signal 36 } 
	{ p_read122 sc_in sc_lv 32 signal 37 } 
	{ ap_return_0 sc_out sc_lv 32 signal -1 } 
	{ ap_return_1 sc_out sc_lv 32 signal -1 } 
	{ ap_return_2 sc_out sc_lv 32 signal -1 } 
	{ ap_return_3 sc_out sc_lv 32 signal -1 } 
	{ ap_return_4 sc_out sc_lv 32 signal -1 } 
	{ ap_return_5 sc_out sc_lv 32 signal -1 } 
	{ ap_return_6 sc_out sc_lv 32 signal -1 } 
	{ ap_return_7 sc_out sc_lv 32 signal -1 } 
	{ ap_return_8 sc_out sc_lv 32 signal -1 } 
	{ ap_return_9 sc_out sc_lv 32 signal -1 } 
	{ ap_return_10 sc_out sc_lv 32 signal -1 } 
	{ ap_return_11 sc_out sc_lv 32 signal -1 } 
	{ ap_return_12 sc_out sc_lv 32 signal -1 } 
	{ ap_return_13 sc_out sc_lv 32 signal -1 } 
	{ ap_return_14 sc_out sc_lv 32 signal -1 } 
	{ ap_return_15 sc_out sc_lv 32 signal -1 } 
	{ ap_return_16 sc_out sc_lv 32 signal -1 } 
	{ ap_return_17 sc_out sc_lv 32 signal -1 } 
	{ ap_return_18 sc_out sc_lv 32 signal -1 } 
	{ ap_return_19 sc_out sc_lv 32 signal -1 } 
	{ ap_return_20 sc_out sc_lv 32 signal -1 } 
	{ ap_return_21 sc_out sc_lv 32 signal -1 } 
	{ ap_return_22 sc_out sc_lv 32 signal -1 } 
	{ ap_return_23 sc_out sc_lv 32 signal -1 } 
	{ ap_return_24 sc_out sc_lv 32 signal -1 } 
	{ ap_return_25 sc_out sc_lv 32 signal -1 } 
	{ ap_return_26 sc_out sc_lv 32 signal -1 } 
	{ ap_return_27 sc_out sc_lv 32 signal -1 } 
	{ ap_return_28 sc_out sc_lv 32 signal -1 } 
	{ ap_return_29 sc_out sc_lv 32 signal -1 } 
	{ ap_return_30 sc_out sc_lv 32 signal -1 } 
	{ ap_return_31 sc_out sc_lv 32 signal -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "wide_trip_count_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "wide_trip_count", "role": "dout" }} , 
 	{ "name": "wide_trip_count_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "wide_trip_count", "role": "empty_n" }} , 
 	{ "name": "wide_trip_count_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "wide_trip_count", "role": "read" }} , 
 	{ "name": "wide_trip_count_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "wide_trip_count", "role": "num_data_valid" }} , 
 	{ "name": "wide_trip_count_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "wide_trip_count", "role": "fifo_cap" }} , 
 	{ "name": "xi_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "xi", "role": "dout" }} , 
 	{ "name": "xi_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi", "role": "empty_n" }} , 
 	{ "name": "xi_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi", "role": "read" }} , 
 	{ "name": "xi_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "xi", "role": "num_data_valid" }} , 
 	{ "name": "xi_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "xi", "role": "fifo_cap" }} , 
 	{ "name": "mro0_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro0", "role": "dout" }} , 
 	{ "name": "mro0_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro0", "role": "empty_n" }} , 
 	{ "name": "mro0_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro0", "role": "read" }} , 
 	{ "name": "mro0_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro0", "role": "num_data_valid" }} , 
 	{ "name": "mro0_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro0", "role": "fifo_cap" }} , 
 	{ "name": "mro1_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro1", "role": "dout" }} , 
 	{ "name": "mro1_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1", "role": "empty_n" }} , 
 	{ "name": "mro1_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1", "role": "read" }} , 
 	{ "name": "mro1_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro1", "role": "num_data_valid" }} , 
 	{ "name": "mro1_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro1", "role": "fifo_cap" }} , 
 	{ "name": "mro2_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro2", "role": "dout" }} , 
 	{ "name": "mro2_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro2", "role": "empty_n" }} , 
 	{ "name": "mro2_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro2", "role": "read" }} , 
 	{ "name": "mro2_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro2", "role": "num_data_valid" }} , 
 	{ "name": "mro2_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro2", "role": "fifo_cap" }} , 
 	{ "name": "mro3_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro3", "role": "dout" }} , 
 	{ "name": "mro3_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro3", "role": "empty_n" }} , 
 	{ "name": "mro3_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro3", "role": "read" }} , 
 	{ "name": "mro3_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro3", "role": "num_data_valid" }} , 
 	{ "name": "mro3_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro3", "role": "fifo_cap" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "p_read2", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read2", "role": "default" }} , 
 	{ "name": "p_read6", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read6", "role": "default" }} , 
 	{ "name": "p_read10", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read10", "role": "default" }} , 
 	{ "name": "p_read14", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read14", "role": "default" }} , 
 	{ "name": "p_read18", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read18", "role": "default" }} , 
 	{ "name": "p_read22", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read22", "role": "default" }} , 
 	{ "name": "p_read26", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read26", "role": "default" }} , 
 	{ "name": "p_read30", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read30", "role": "default" }} , 
 	{ "name": "p_read34", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read34", "role": "default" }} , 
 	{ "name": "p_read38", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read38", "role": "default" }} , 
 	{ "name": "p_read42", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read42", "role": "default" }} , 
 	{ "name": "p_read46", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read46", "role": "default" }} , 
 	{ "name": "p_read50", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read50", "role": "default" }} , 
 	{ "name": "p_read54", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read54", "role": "default" }} , 
 	{ "name": "p_read58", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read58", "role": "default" }} , 
 	{ "name": "p_read62", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read62", "role": "default" }} , 
 	{ "name": "p_read66", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read66", "role": "default" }} , 
 	{ "name": "p_read70", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read70", "role": "default" }} , 
 	{ "name": "p_read74", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read74", "role": "default" }} , 
 	{ "name": "p_read78", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read78", "role": "default" }} , 
 	{ "name": "p_read82", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read82", "role": "default" }} , 
 	{ "name": "p_read86", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read86", "role": "default" }} , 
 	{ "name": "p_read90", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read90", "role": "default" }} , 
 	{ "name": "p_read94", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read94", "role": "default" }} , 
 	{ "name": "p_read98", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read98", "role": "default" }} , 
 	{ "name": "p_read102", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read102", "role": "default" }} , 
 	{ "name": "p_read106", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read106", "role": "default" }} , 
 	{ "name": "p_read110", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read110", "role": "default" }} , 
 	{ "name": "p_read114", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read114", "role": "default" }} , 
 	{ "name": "p_read118", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read118", "role": "default" }} , 
 	{ "name": "p_read122", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read122", "role": "default" }} , 
 	{ "name": "ap_return_0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_0", "role": "default" }} , 
 	{ "name": "ap_return_1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_1", "role": "default" }} , 
 	{ "name": "ap_return_2", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_2", "role": "default" }} , 
 	{ "name": "ap_return_3", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_3", "role": "default" }} , 
 	{ "name": "ap_return_4", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_4", "role": "default" }} , 
 	{ "name": "ap_return_5", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_5", "role": "default" }} , 
 	{ "name": "ap_return_6", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_6", "role": "default" }} , 
 	{ "name": "ap_return_7", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_7", "role": "default" }} , 
 	{ "name": "ap_return_8", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_8", "role": "default" }} , 
 	{ "name": "ap_return_9", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_9", "role": "default" }} , 
 	{ "name": "ap_return_10", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_10", "role": "default" }} , 
 	{ "name": "ap_return_11", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_11", "role": "default" }} , 
 	{ "name": "ap_return_12", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_12", "role": "default" }} , 
 	{ "name": "ap_return_13", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_13", "role": "default" }} , 
 	{ "name": "ap_return_14", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_14", "role": "default" }} , 
 	{ "name": "ap_return_15", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_15", "role": "default" }} , 
 	{ "name": "ap_return_16", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_16", "role": "default" }} , 
 	{ "name": "ap_return_17", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_17", "role": "default" }} , 
 	{ "name": "ap_return_18", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_18", "role": "default" }} , 
 	{ "name": "ap_return_19", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_19", "role": "default" }} , 
 	{ "name": "ap_return_20", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_20", "role": "default" }} , 
 	{ "name": "ap_return_21", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_21", "role": "default" }} , 
 	{ "name": "ap_return_22", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_22", "role": "default" }} , 
 	{ "name": "ap_return_23", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_23", "role": "default" }} , 
 	{ "name": "ap_return_24", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_24", "role": "default" }} , 
 	{ "name": "ap_return_25", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_25", "role": "default" }} , 
 	{ "name": "ap_return_26", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_26", "role": "default" }} , 
 	{ "name": "ap_return_27", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_27", "role": "default" }} , 
 	{ "name": "ap_return_28", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_28", "role": "default" }} , 
 	{ "name": "ap_return_29", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_29", "role": "default" }} , 
 	{ "name": "ap_return_30", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_30", "role": "default" }} , 
 	{ "name": "ap_return_31", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_31", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3", "5", "7", "9", "11", "13", "15", "17", "19", "117", "215", "313", "411", "412", "413", "414", "415", "416", "417", "418", "419", "420", "421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432", "433", "434", "435", "436", "437", "438", "439", "440", "441", "442", "443", "444", "445", "446", "447", "448", "449", "450", "451", "452", "453", "454", "455", "456", "457", "458", "459", "460", "461", "462", "463", "464", "465", "466", "467", "468", "469", "470", "471", "472", "473", "474"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2731", "EstimateLatencyMax" : "2731",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "wide_trip_count", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "wide_trip_count_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "xi_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read10", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read14", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read18", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read22", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read26", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read30", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read34", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read38", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read42", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read46", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read50", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read54", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read58", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read62", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read66", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read70", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read74", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read78", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read82", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read86", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read90", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read94", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read98", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read102", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read106", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read110", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read114", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read118", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read122", "Type" : "None", "Direction" : "I"},
			{"Name" : "xi3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_3", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_2", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_1", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_0", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_4", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_5", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_6", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_7", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "19", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_3", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_2", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_1", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_0", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_4", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_5", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_6", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_7", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "117", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_3", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_2", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_1", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_0", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_4", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_5", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_6", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_7", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "215", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_3", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_2", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_1", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_0", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_4", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_5", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_6", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_7", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "313", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_324_2", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "13", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state13"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_read_xi_to_stream_fu_1054", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "read_xi_to_stream",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "xi3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi1_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi2_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi3_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "xi0_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_116_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_read_xi_to_stream_fu_1054.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1_fu_1123", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "qscale0_7_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_6_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_1_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_0_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_3_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_2_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_5_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale0_4_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out1", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out2", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out3", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out6", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out7", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_146_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state1", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state1_blk", "QuitState" : "ap_ST_fsm_state1", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state1_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1_fu_1123.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11_fu_1143", "Parent" : "0", "Child" : ["6"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "qscale1_7_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_6_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_1_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_0_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_3_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_2_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_5_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale1_4_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out1", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out2", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out3", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out6", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out7", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_146_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state1", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state1_blk", "QuitState" : "ap_ST_fsm_state1", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state1_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11_fu_1143.flow_control_loop_pipe_sequential_init_U", "Parent" : "5"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13_fu_1163", "Parent" : "0", "Child" : ["8"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "qscale2_7_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_6_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_1_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_0_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_3_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_2_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_5_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale2_4_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out1", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out2", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out3", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out6", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out7", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_146_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state1", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state1_blk", "QuitState" : "ap_ST_fsm_state1", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state1_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13_fu_1163.flow_control_loop_pipe_sequential_init_U", "Parent" : "7"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15_fu_1183", "Parent" : "0", "Child" : ["10"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "qscale3_7_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_6_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_1_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_0_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_3_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_2_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_5_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale3_4_promoted", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out1", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out2", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out3", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out6", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_out7", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_146_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state1", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state1_blk", "QuitState" : "ap_ST_fsm_state1", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state1_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15_fu_1183.flow_control_loop_pipe_sequential_init_U", "Parent" : "9"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Parent" : "0", "Child" : ["12"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_0_0_3742_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_2741_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_1740_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "empty", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro0_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_154_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203.flow_control_loop_pipe_sequential_init_U", "Parent" : "11"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Parent" : "0", "Child" : ["14"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_0_0_3721_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_2720_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_1719_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "empty", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro1_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_154_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227.flow_control_loop_pipe_sequential_init_U", "Parent" : "13"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Parent" : "0", "Child" : ["16"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_0_0_3700_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_2699_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_1698_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "empty", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro2_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_154_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251.flow_control_loop_pipe_sequential_init_U", "Parent" : "15"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Parent" : "0", "Child" : ["18"],
		"CDFG" : "Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_0_0_3679_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_2678_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_0_0_1677_partselect", "Type" : "None", "Direction" : "I"},
			{"Name" : "empty", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_3_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_5_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_6_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "mro3_s_M_elems_V_7_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_154_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275.flow_control_loop_pipe_sequential_init_U", "Parent" : "17"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299", "Parent" : "0", "Child" : ["20", "30", "40", "50", "60", "70", "80", "90", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116"],
		"CDFG" : "compute_mac",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "93", "EstimateLatencyMax" : "93",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "30", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "40", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "50", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "60", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "70", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "80", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "90", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "30", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "40", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "50", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "60", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "70", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "80", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "90", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "qzeros_0_val8", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val16", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val24", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val32", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val40", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val48", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val56", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val64", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val72", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val81", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val89", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val98", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val106", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val115", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val123", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val132", "Type" : "None", "Direction" : "I"},
			{"Name" : "pout_local_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_7", "Type" : "OVld", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "lp_cmp_mac_cplocal", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter24", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state2"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter24", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state28"]}}]},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360", "Parent" : "19", "Child" : ["21", "22", "23", "24", "25", "26", "27", "28", "29"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "21", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "20"},
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "20"},
	{"ID" : "23", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "20"},
	{"ID" : "24", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "20"},
	{"ID" : "25", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "20"},
	{"ID" : "26", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "20"},
	{"ID" : "27", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "20"},
	{"ID" : "28", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "20"},
	{"ID" : "29", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "20"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400", "Parent" : "19", "Child" : ["31", "32", "33", "34", "35", "36", "37", "38", "39"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "30"},
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "30"},
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "30"},
	{"ID" : "34", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "30"},
	{"ID" : "35", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "30"},
	{"ID" : "36", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "30"},
	{"ID" : "37", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "30"},
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "30"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "30"},
	{"ID" : "40", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440", "Parent" : "19", "Child" : ["41", "42", "43", "44", "45", "46", "47", "48", "49"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "40"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "40"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "40"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "40"},
	{"ID" : "45", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "40"},
	{"ID" : "46", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "40"},
	{"ID" : "47", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "40"},
	{"ID" : "48", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "40"},
	{"ID" : "49", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "40"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480", "Parent" : "19", "Child" : ["51", "52", "53", "54", "55", "56", "57", "58", "59"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "51", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "50"},
	{"ID" : "52", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "50"},
	{"ID" : "53", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "50"},
	{"ID" : "54", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "50"},
	{"ID" : "55", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "50"},
	{"ID" : "56", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "50"},
	{"ID" : "57", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "50"},
	{"ID" : "58", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "50"},
	{"ID" : "59", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "50"},
	{"ID" : "60", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520", "Parent" : "19", "Child" : ["61", "62", "63", "64", "65", "66", "67", "68", "69"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "61", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "60"},
	{"ID" : "62", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "60"},
	{"ID" : "63", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "60"},
	{"ID" : "64", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "60"},
	{"ID" : "65", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "60"},
	{"ID" : "66", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "60"},
	{"ID" : "67", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "60"},
	{"ID" : "68", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "60"},
	{"ID" : "69", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "60"},
	{"ID" : "70", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560", "Parent" : "19", "Child" : ["71", "72", "73", "74", "75", "76", "77", "78", "79"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "71", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "70"},
	{"ID" : "72", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "70"},
	{"ID" : "73", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "70"},
	{"ID" : "74", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "70"},
	{"ID" : "75", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "70"},
	{"ID" : "76", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "70"},
	{"ID" : "77", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "70"},
	{"ID" : "78", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "70"},
	{"ID" : "79", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "70"},
	{"ID" : "80", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600", "Parent" : "19", "Child" : ["81", "82", "83", "84", "85", "86", "87", "88", "89"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "81", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "80"},
	{"ID" : "82", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "80"},
	{"ID" : "83", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "80"},
	{"ID" : "84", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "80"},
	{"ID" : "85", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "80"},
	{"ID" : "86", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "80"},
	{"ID" : "87", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "80"},
	{"ID" : "88", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "80"},
	{"ID" : "89", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "80"},
	{"ID" : "90", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640", "Parent" : "19", "Child" : ["91", "92", "93", "94", "95", "96", "97", "98", "99"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "91", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "90"},
	{"ID" : "92", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "90"},
	{"ID" : "93", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "90"},
	{"ID" : "94", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "90"},
	{"ID" : "95", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "90"},
	{"ID" : "96", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "90"},
	{"ID" : "97", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "90"},
	{"ID" : "98", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "90"},
	{"ID" : "99", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "90"},
	{"ID" : "100", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "19"},
	{"ID" : "101", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "19"},
	{"ID" : "102", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "19"},
	{"ID" : "103", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "19"},
	{"ID" : "104", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "19"},
	{"ID" : "105", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "19"},
	{"ID" : "106", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "19"},
	{"ID" : "107", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "19"},
	{"ID" : "108", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U195", "Parent" : "19"},
	{"ID" : "109", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U196", "Parent" : "19"},
	{"ID" : "110", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U197", "Parent" : "19"},
	{"ID" : "111", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U198", "Parent" : "19"},
	{"ID" : "112", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U199", "Parent" : "19"},
	{"ID" : "113", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U200", "Parent" : "19"},
	{"ID" : "114", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U201", "Parent" : "19"},
	{"ID" : "115", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U202", "Parent" : "19"},
	{"ID" : "116", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U203", "Parent" : "19"},
	{"ID" : "117", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359", "Parent" : "0", "Child" : ["118", "128", "138", "148", "158", "168", "178", "188", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214"],
		"CDFG" : "compute_mac",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "93", "EstimateLatencyMax" : "93",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "118", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "128", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "138", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "148", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "158", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "168", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "178", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "188", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "118", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "128", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "138", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "148", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "158", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "168", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "178", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "188", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "qzeros_0_val8", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val16", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val24", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val32", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val40", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val48", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val56", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val64", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val72", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val81", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val89", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val98", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val106", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val115", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val123", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val132", "Type" : "None", "Direction" : "I"},
			{"Name" : "pout_local_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_7", "Type" : "OVld", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "lp_cmp_mac_cplocal", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter24", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state2"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter24", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state28"]}}]},
	{"ID" : "118", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360", "Parent" : "117", "Child" : ["119", "120", "121", "122", "123", "124", "125", "126", "127"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "119", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "118"},
	{"ID" : "120", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "118"},
	{"ID" : "121", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "118"},
	{"ID" : "122", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "118"},
	{"ID" : "123", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "118"},
	{"ID" : "124", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "118"},
	{"ID" : "125", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "118"},
	{"ID" : "126", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "118"},
	{"ID" : "127", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "118"},
	{"ID" : "128", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400", "Parent" : "117", "Child" : ["129", "130", "131", "132", "133", "134", "135", "136", "137"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "129", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "128"},
	{"ID" : "130", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "128"},
	{"ID" : "131", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "128"},
	{"ID" : "132", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "128"},
	{"ID" : "133", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "128"},
	{"ID" : "134", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "128"},
	{"ID" : "135", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "128"},
	{"ID" : "136", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "128"},
	{"ID" : "137", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "128"},
	{"ID" : "138", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440", "Parent" : "117", "Child" : ["139", "140", "141", "142", "143", "144", "145", "146", "147"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "139", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "138"},
	{"ID" : "140", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "138"},
	{"ID" : "141", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "138"},
	{"ID" : "142", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "138"},
	{"ID" : "143", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "138"},
	{"ID" : "144", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "138"},
	{"ID" : "145", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "138"},
	{"ID" : "146", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "138"},
	{"ID" : "147", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "138"},
	{"ID" : "148", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480", "Parent" : "117", "Child" : ["149", "150", "151", "152", "153", "154", "155", "156", "157"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "149", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "148"},
	{"ID" : "150", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "148"},
	{"ID" : "151", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "148"},
	{"ID" : "152", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "148"},
	{"ID" : "153", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "148"},
	{"ID" : "154", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "148"},
	{"ID" : "155", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "148"},
	{"ID" : "156", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "148"},
	{"ID" : "157", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "148"},
	{"ID" : "158", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520", "Parent" : "117", "Child" : ["159", "160", "161", "162", "163", "164", "165", "166", "167"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "159", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "158"},
	{"ID" : "160", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "158"},
	{"ID" : "161", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "158"},
	{"ID" : "162", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "158"},
	{"ID" : "163", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "158"},
	{"ID" : "164", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "158"},
	{"ID" : "165", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "158"},
	{"ID" : "166", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "158"},
	{"ID" : "167", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "158"},
	{"ID" : "168", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560", "Parent" : "117", "Child" : ["169", "170", "171", "172", "173", "174", "175", "176", "177"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "169", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "168"},
	{"ID" : "170", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "168"},
	{"ID" : "171", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "168"},
	{"ID" : "172", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "168"},
	{"ID" : "173", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "168"},
	{"ID" : "174", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "168"},
	{"ID" : "175", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "168"},
	{"ID" : "176", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "168"},
	{"ID" : "177", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "168"},
	{"ID" : "178", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600", "Parent" : "117", "Child" : ["179", "180", "181", "182", "183", "184", "185", "186", "187"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "179", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "178"},
	{"ID" : "180", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "178"},
	{"ID" : "181", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "178"},
	{"ID" : "182", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "178"},
	{"ID" : "183", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "178"},
	{"ID" : "184", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "178"},
	{"ID" : "185", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "178"},
	{"ID" : "186", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "178"},
	{"ID" : "187", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "178"},
	{"ID" : "188", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640", "Parent" : "117", "Child" : ["189", "190", "191", "192", "193", "194", "195", "196", "197"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "189", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "188"},
	{"ID" : "190", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "188"},
	{"ID" : "191", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "188"},
	{"ID" : "192", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "188"},
	{"ID" : "193", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "188"},
	{"ID" : "194", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "188"},
	{"ID" : "195", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "188"},
	{"ID" : "196", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "188"},
	{"ID" : "197", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "188"},
	{"ID" : "198", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "117"},
	{"ID" : "199", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "117"},
	{"ID" : "200", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "117"},
	{"ID" : "201", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "117"},
	{"ID" : "202", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "117"},
	{"ID" : "203", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "117"},
	{"ID" : "204", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "117"},
	{"ID" : "205", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "117"},
	{"ID" : "206", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U195", "Parent" : "117"},
	{"ID" : "207", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U196", "Parent" : "117"},
	{"ID" : "208", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U197", "Parent" : "117"},
	{"ID" : "209", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U198", "Parent" : "117"},
	{"ID" : "210", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U199", "Parent" : "117"},
	{"ID" : "211", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U200", "Parent" : "117"},
	{"ID" : "212", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U201", "Parent" : "117"},
	{"ID" : "213", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U202", "Parent" : "117"},
	{"ID" : "214", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U203", "Parent" : "117"},
	{"ID" : "215", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419", "Parent" : "0", "Child" : ["216", "226", "236", "246", "256", "266", "276", "286", "296", "297", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"],
		"CDFG" : "compute_mac",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "93", "EstimateLatencyMax" : "93",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "216", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "226", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "236", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "246", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "256", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "266", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "276", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "286", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "216", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "226", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "236", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "246", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "256", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "266", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "276", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "286", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "qzeros_0_val8", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val16", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val24", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val32", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val40", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val48", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val56", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val64", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val72", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val81", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val89", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val98", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val106", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val115", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val123", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val132", "Type" : "None", "Direction" : "I"},
			{"Name" : "pout_local_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_7", "Type" : "OVld", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "lp_cmp_mac_cplocal", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter24", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state2"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter24", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state28"]}}]},
	{"ID" : "216", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360", "Parent" : "215", "Child" : ["217", "218", "219", "220", "221", "222", "223", "224", "225"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "217", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "216"},
	{"ID" : "218", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "216"},
	{"ID" : "219", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "216"},
	{"ID" : "220", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "216"},
	{"ID" : "221", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "216"},
	{"ID" : "222", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "216"},
	{"ID" : "223", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "216"},
	{"ID" : "224", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "216"},
	{"ID" : "225", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "216"},
	{"ID" : "226", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400", "Parent" : "215", "Child" : ["227", "228", "229", "230", "231", "232", "233", "234", "235"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "227", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "226"},
	{"ID" : "228", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "226"},
	{"ID" : "229", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "226"},
	{"ID" : "230", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "226"},
	{"ID" : "231", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "226"},
	{"ID" : "232", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "226"},
	{"ID" : "233", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "226"},
	{"ID" : "234", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "226"},
	{"ID" : "235", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "226"},
	{"ID" : "236", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440", "Parent" : "215", "Child" : ["237", "238", "239", "240", "241", "242", "243", "244", "245"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "237", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "236"},
	{"ID" : "238", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "236"},
	{"ID" : "239", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "236"},
	{"ID" : "240", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "236"},
	{"ID" : "241", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "236"},
	{"ID" : "242", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "236"},
	{"ID" : "243", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "236"},
	{"ID" : "244", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "236"},
	{"ID" : "245", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "236"},
	{"ID" : "246", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480", "Parent" : "215", "Child" : ["247", "248", "249", "250", "251", "252", "253", "254", "255"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "247", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "246"},
	{"ID" : "248", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "246"},
	{"ID" : "249", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "246"},
	{"ID" : "250", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "246"},
	{"ID" : "251", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "246"},
	{"ID" : "252", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "246"},
	{"ID" : "253", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "246"},
	{"ID" : "254", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "246"},
	{"ID" : "255", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "246"},
	{"ID" : "256", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520", "Parent" : "215", "Child" : ["257", "258", "259", "260", "261", "262", "263", "264", "265"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "257", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "256"},
	{"ID" : "258", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "256"},
	{"ID" : "259", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "256"},
	{"ID" : "260", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "256"},
	{"ID" : "261", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "256"},
	{"ID" : "262", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "256"},
	{"ID" : "263", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "256"},
	{"ID" : "264", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "256"},
	{"ID" : "265", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "256"},
	{"ID" : "266", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560", "Parent" : "215", "Child" : ["267", "268", "269", "270", "271", "272", "273", "274", "275"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "267", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "266"},
	{"ID" : "268", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "266"},
	{"ID" : "269", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "266"},
	{"ID" : "270", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "266"},
	{"ID" : "271", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "266"},
	{"ID" : "272", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "266"},
	{"ID" : "273", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "266"},
	{"ID" : "274", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "266"},
	{"ID" : "275", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "266"},
	{"ID" : "276", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600", "Parent" : "215", "Child" : ["277", "278", "279", "280", "281", "282", "283", "284", "285"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "277", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "276"},
	{"ID" : "278", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "276"},
	{"ID" : "279", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "276"},
	{"ID" : "280", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "276"},
	{"ID" : "281", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "276"},
	{"ID" : "282", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "276"},
	{"ID" : "283", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "276"},
	{"ID" : "284", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "276"},
	{"ID" : "285", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "276"},
	{"ID" : "286", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640", "Parent" : "215", "Child" : ["287", "288", "289", "290", "291", "292", "293", "294", "295"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "287", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "286"},
	{"ID" : "288", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "286"},
	{"ID" : "289", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "286"},
	{"ID" : "290", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "286"},
	{"ID" : "291", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "286"},
	{"ID" : "292", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "286"},
	{"ID" : "293", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "286"},
	{"ID" : "294", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "286"},
	{"ID" : "295", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "286"},
	{"ID" : "296", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "215"},
	{"ID" : "297", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "215"},
	{"ID" : "298", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "215"},
	{"ID" : "299", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "215"},
	{"ID" : "300", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "215"},
	{"ID" : "301", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "215"},
	{"ID" : "302", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "215"},
	{"ID" : "303", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "215"},
	{"ID" : "304", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U195", "Parent" : "215"},
	{"ID" : "305", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U196", "Parent" : "215"},
	{"ID" : "306", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U197", "Parent" : "215"},
	{"ID" : "307", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U198", "Parent" : "215"},
	{"ID" : "308", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U199", "Parent" : "215"},
	{"ID" : "309", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U200", "Parent" : "215"},
	{"ID" : "310", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U201", "Parent" : "215"},
	{"ID" : "311", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U202", "Parent" : "215"},
	{"ID" : "312", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U203", "Parent" : "215"},
	{"ID" : "313", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479", "Parent" : "0", "Child" : ["314", "324", "334", "344", "354", "364", "374", "384", "394", "395", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410"],
		"CDFG" : "compute_mac",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "93", "EstimateLatencyMax" : "93",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "314", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "324", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "334", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "344", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "354", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "364", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "374", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "384", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "314", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "324", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "334", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "344", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "354", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "364", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "374", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "384", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "qzeros_0_val8", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val16", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val24", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val32", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val40", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val48", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val56", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val64", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val72", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val81", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val89", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val98", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val106", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val115", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val123", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val132", "Type" : "None", "Direction" : "I"},
			{"Name" : "pout_local_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pout_local_7", "Type" : "OVld", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "lp_cmp_mac_cplocal", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter24", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state2"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter24", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state28"]}}]},
	{"ID" : "314", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360", "Parent" : "313", "Child" : ["315", "316", "317", "318", "319", "320", "321", "322", "323"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "315", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "314"},
	{"ID" : "316", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "314"},
	{"ID" : "317", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "314"},
	{"ID" : "318", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "314"},
	{"ID" : "319", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "314"},
	{"ID" : "320", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "314"},
	{"ID" : "321", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "314"},
	{"ID" : "322", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "314"},
	{"ID" : "323", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "314"},
	{"ID" : "324", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400", "Parent" : "313", "Child" : ["325", "326", "327", "328", "329", "330", "331", "332", "333"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "325", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "324"},
	{"ID" : "326", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "324"},
	{"ID" : "327", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "324"},
	{"ID" : "328", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "324"},
	{"ID" : "329", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "324"},
	{"ID" : "330", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "324"},
	{"ID" : "331", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "324"},
	{"ID" : "332", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "324"},
	{"ID" : "333", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "324"},
	{"ID" : "334", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440", "Parent" : "313", "Child" : ["335", "336", "337", "338", "339", "340", "341", "342", "343"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "335", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "334"},
	{"ID" : "336", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "334"},
	{"ID" : "337", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "334"},
	{"ID" : "338", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "334"},
	{"ID" : "339", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "334"},
	{"ID" : "340", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "334"},
	{"ID" : "341", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "334"},
	{"ID" : "342", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "334"},
	{"ID" : "343", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "334"},
	{"ID" : "344", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480", "Parent" : "313", "Child" : ["345", "346", "347", "348", "349", "350", "351", "352", "353"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "345", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "344"},
	{"ID" : "346", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "344"},
	{"ID" : "347", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "344"},
	{"ID" : "348", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "344"},
	{"ID" : "349", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "344"},
	{"ID" : "350", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "344"},
	{"ID" : "351", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "344"},
	{"ID" : "352", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "344"},
	{"ID" : "353", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "344"},
	{"ID" : "354", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520", "Parent" : "313", "Child" : ["355", "356", "357", "358", "359", "360", "361", "362", "363"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "355", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "354"},
	{"ID" : "356", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "354"},
	{"ID" : "357", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "354"},
	{"ID" : "358", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "354"},
	{"ID" : "359", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "354"},
	{"ID" : "360", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "354"},
	{"ID" : "361", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "354"},
	{"ID" : "362", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "354"},
	{"ID" : "363", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "354"},
	{"ID" : "364", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560", "Parent" : "313", "Child" : ["365", "366", "367", "368", "369", "370", "371", "372", "373"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "365", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "364"},
	{"ID" : "366", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "364"},
	{"ID" : "367", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "364"},
	{"ID" : "368", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "364"},
	{"ID" : "369", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "364"},
	{"ID" : "370", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "364"},
	{"ID" : "371", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "364"},
	{"ID" : "372", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "364"},
	{"ID" : "373", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "364"},
	{"ID" : "374", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600", "Parent" : "313", "Child" : ["375", "376", "377", "378", "379", "380", "381", "382", "383"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "375", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "374"},
	{"ID" : "376", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "374"},
	{"ID" : "377", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "374"},
	{"ID" : "378", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "374"},
	{"ID" : "379", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "374"},
	{"ID" : "380", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "374"},
	{"ID" : "381", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "374"},
	{"ID" : "382", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "374"},
	{"ID" : "383", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "374"},
	{"ID" : "384", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640", "Parent" : "313", "Child" : ["385", "386", "387", "388", "389", "390", "391", "392", "393"],
		"CDFG" : "compute_mac_sub",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "59", "EstimateLatencyMax" : "59",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "xi_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro_s_0", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "mro_s_0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "qzeros_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qzeros_7_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_1_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_2_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_3_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_4_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_5_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_6_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "qscale_7_val", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "lp_cmp_sub_h", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage2", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage2_subdone", "QuitState" : "ap_ST_fsm_pp0_stage2", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage2_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "385", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "384"},
	{"ID" : "386", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "384"},
	{"ID" : "387", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "384"},
	{"ID" : "388", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "384"},
	{"ID" : "389", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "384"},
	{"ID" : "390", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "384"},
	{"ID" : "391", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "384"},
	{"ID" : "392", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "384"},
	{"ID" : "393", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "384"},
	{"ID" : "394", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "313"},
	{"ID" : "395", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "313"},
	{"ID" : "396", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "313"},
	{"ID" : "397", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "313"},
	{"ID" : "398", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "313"},
	{"ID" : "399", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "313"},
	{"ID" : "400", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "313"},
	{"ID" : "401", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "313"},
	{"ID" : "402", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U195", "Parent" : "313"},
	{"ID" : "403", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U196", "Parent" : "313"},
	{"ID" : "404", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U197", "Parent" : "313"},
	{"ID" : "405", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U198", "Parent" : "313"},
	{"ID" : "406", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U199", "Parent" : "313"},
	{"ID" : "407", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U200", "Parent" : "313"},
	{"ID" : "408", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U201", "Parent" : "313"},
	{"ID" : "409", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U202", "Parent" : "313"},
	{"ID" : "410", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U203", "Parent" : "313"},
	{"ID" : "411", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "412", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "413", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "414", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "415", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "416", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "417", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "418", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi0_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "419", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "420", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "421", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "422", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "423", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "424", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "425", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "426", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi1_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "427", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "428", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "429", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "430", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "431", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "432", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "433", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "434", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi2_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "435", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "436", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "437", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "438", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "439", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "440", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "441", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "442", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi3_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "443", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "444", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "445", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "446", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "447", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "448", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "449", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "450", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "451", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "452", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "453", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "454", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "455", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "456", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "457", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "458", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "459", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "460", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "461", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "462", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "463", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "464", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "465", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "466", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_s_M_elems_V_7_fifo_U", "Parent" : "0"},
	{"ID" : "467", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_0_fifo_U", "Parent" : "0"},
	{"ID" : "468", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_1_fifo_U", "Parent" : "0"},
	{"ID" : "469", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_2_fifo_U", "Parent" : "0"},
	{"ID" : "470", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_3_fifo_U", "Parent" : "0"},
	{"ID" : "471", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_4_fifo_U", "Parent" : "0"},
	{"ID" : "472", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_5_fifo_U", "Parent" : "0"},
	{"ID" : "473", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_6_fifo_U", "Parent" : "0"},
	{"ID" : "474", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_s_M_elems_V_7_fifo_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	Loop_VITIS_LOOP_324_2_proc {
		wide_trip_count {Type I LastRead 0 FirstWrite -1}
		xi {Type I LastRead 0 FirstWrite -1}
		mro0 {Type I LastRead 0 FirstWrite -1}
		mro1 {Type I LastRead 0 FirstWrite -1}
		mro2 {Type I LastRead 0 FirstWrite -1}
		mro3 {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read10 {Type I LastRead 0 FirstWrite -1}
		p_read14 {Type I LastRead 0 FirstWrite -1}
		p_read18 {Type I LastRead 0 FirstWrite -1}
		p_read22 {Type I LastRead 0 FirstWrite -1}
		p_read26 {Type I LastRead 0 FirstWrite -1}
		p_read30 {Type I LastRead 0 FirstWrite -1}
		p_read34 {Type I LastRead 0 FirstWrite -1}
		p_read38 {Type I LastRead 0 FirstWrite -1}
		p_read42 {Type I LastRead 0 FirstWrite -1}
		p_read46 {Type I LastRead 0 FirstWrite -1}
		p_read50 {Type I LastRead 0 FirstWrite -1}
		p_read54 {Type I LastRead 0 FirstWrite -1}
		p_read58 {Type I LastRead 0 FirstWrite -1}
		p_read62 {Type I LastRead 0 FirstWrite -1}
		p_read66 {Type I LastRead 0 FirstWrite -1}
		p_read70 {Type I LastRead 0 FirstWrite -1}
		p_read74 {Type I LastRead 0 FirstWrite -1}
		p_read78 {Type I LastRead 0 FirstWrite -1}
		p_read82 {Type I LastRead 0 FirstWrite -1}
		p_read86 {Type I LastRead 0 FirstWrite -1}
		p_read90 {Type I LastRead 0 FirstWrite -1}
		p_read94 {Type I LastRead 0 FirstWrite -1}
		p_read98 {Type I LastRead 0 FirstWrite -1}
		p_read102 {Type I LastRead 0 FirstWrite -1}
		p_read106 {Type I LastRead 0 FirstWrite -1}
		p_read110 {Type I LastRead 0 FirstWrite -1}
		p_read114 {Type I LastRead 0 FirstWrite -1}
		p_read118 {Type I LastRead 0 FirstWrite -1}
		p_read122 {Type I LastRead 0 FirstWrite -1}
		xi3_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		xi1_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		xi2_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		xi3_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		xi0_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		mro0_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		mro1_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		mro2_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_3 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_2 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_1 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_0 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_4 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_5 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_6 {Type IO LastRead -1 FirstWrite -1}
		mro3_s_M_elems_V_7 {Type IO LastRead -1 FirstWrite -1}}
	read_xi_to_stream {
		p_read {Type I LastRead 0 FirstWrite -1}
		xi3_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}
		xi1_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}
		xi2_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}
		xi3_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		xi0_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1 {
		qscale0_7_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_6_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_1_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_0_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_3_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_2_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_5_promoted {Type I LastRead 0 FirstWrite -1}
		qscale0_4_promoted {Type I LastRead 0 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11 {
		qscale1_7_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_6_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_1_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_0_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_3_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_2_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_5_promoted {Type I LastRead 0 FirstWrite -1}
		qscale1_4_promoted {Type I LastRead 0 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13 {
		qscale2_7_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_6_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_1_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_0_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_3_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_2_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_5_promoted {Type I LastRead 0 FirstWrite -1}
		qscale2_4_promoted {Type I LastRead 0 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15 {
		qscale3_7_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_6_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_1_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_0_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_3_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_2_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_5_promoted {Type I LastRead 0 FirstWrite -1}
		qscale3_4_promoted {Type I LastRead 0 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2 {
		p_0_0_3742_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_2741_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_1740_partselect {Type I LastRead 0 FirstWrite -1}
		empty {Type I LastRead 0 FirstWrite -1}
		mro0_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		mro0_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22 {
		p_0_0_3721_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_2720_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_1719_partselect {Type I LastRead 0 FirstWrite -1}
		empty {Type I LastRead 0 FirstWrite -1}
		mro1_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		mro1_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24 {
		p_0_0_3700_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_2699_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_1698_partselect {Type I LastRead 0 FirstWrite -1}
		empty {Type I LastRead 0 FirstWrite -1}
		mro2_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		mro2_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}}
	Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26 {
		p_0_0_3679_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_2678_partselect {Type I LastRead 0 FirstWrite -1}
		p_0_0_1677_partselect {Type I LastRead 0 FirstWrite -1}
		empty {Type I LastRead 0 FirstWrite -1}
		mro3_s_M_elems_V_3 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_2 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_1 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_0 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_5 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_6 {Type O LastRead -1 FirstWrite 1}
		mro3_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}}
	compute_mac {
		xi_s_0_0 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_01 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_02 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_03 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_04 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_05 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_06 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_07 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_08 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_09 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_010 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_011 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_012 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_013 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_014 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val8 {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val16 {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val24 {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val32 {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val40 {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val48 {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val56 {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val64 {Type I LastRead 0 FirstWrite -1}
		qscale_0_val72 {Type I LastRead 0 FirstWrite -1}
		qscale_1_val81 {Type I LastRead 0 FirstWrite -1}
		qscale_2_val89 {Type I LastRead 0 FirstWrite -1}
		qscale_3_val98 {Type I LastRead 0 FirstWrite -1}
		qscale_4_val106 {Type I LastRead 0 FirstWrite -1}
		qscale_5_val115 {Type I LastRead 0 FirstWrite -1}
		qscale_6_val123 {Type I LastRead 0 FirstWrite -1}
		qscale_7_val132 {Type I LastRead 0 FirstWrite -1}
		pout_local_0 {Type IO LastRead 20 FirstWrite 26}
		pout_local_1 {Type IO LastRead 20 FirstWrite 26}
		pout_local_2 {Type IO LastRead 20 FirstWrite 26}
		pout_local_3 {Type IO LastRead 20 FirstWrite 26}
		pout_local_4 {Type IO LastRead 20 FirstWrite 26}
		pout_local_5 {Type IO LastRead 20 FirstWrite 26}
		pout_local_6 {Type IO LastRead 20 FirstWrite 26}
		pout_local_7 {Type IO LastRead 20 FirstWrite 26}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac {
		xi_s_0_0 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_01 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_02 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_03 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_04 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_05 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_06 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_07 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_08 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_09 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_010 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_011 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_012 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_013 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_014 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val8 {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val16 {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val24 {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val32 {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val40 {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val48 {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val56 {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val64 {Type I LastRead 0 FirstWrite -1}
		qscale_0_val72 {Type I LastRead 0 FirstWrite -1}
		qscale_1_val81 {Type I LastRead 0 FirstWrite -1}
		qscale_2_val89 {Type I LastRead 0 FirstWrite -1}
		qscale_3_val98 {Type I LastRead 0 FirstWrite -1}
		qscale_4_val106 {Type I LastRead 0 FirstWrite -1}
		qscale_5_val115 {Type I LastRead 0 FirstWrite -1}
		qscale_6_val123 {Type I LastRead 0 FirstWrite -1}
		qscale_7_val132 {Type I LastRead 0 FirstWrite -1}
		pout_local_0 {Type IO LastRead 20 FirstWrite 26}
		pout_local_1 {Type IO LastRead 20 FirstWrite 26}
		pout_local_2 {Type IO LastRead 20 FirstWrite 26}
		pout_local_3 {Type IO LastRead 20 FirstWrite 26}
		pout_local_4 {Type IO LastRead 20 FirstWrite 26}
		pout_local_5 {Type IO LastRead 20 FirstWrite 26}
		pout_local_6 {Type IO LastRead 20 FirstWrite 26}
		pout_local_7 {Type IO LastRead 20 FirstWrite 26}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac {
		xi_s_0_0 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_01 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_02 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_03 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_04 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_05 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_06 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_07 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_08 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_09 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_010 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_011 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_012 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_013 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_014 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val8 {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val16 {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val24 {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val32 {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val40 {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val48 {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val56 {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val64 {Type I LastRead 0 FirstWrite -1}
		qscale_0_val72 {Type I LastRead 0 FirstWrite -1}
		qscale_1_val81 {Type I LastRead 0 FirstWrite -1}
		qscale_2_val89 {Type I LastRead 0 FirstWrite -1}
		qscale_3_val98 {Type I LastRead 0 FirstWrite -1}
		qscale_4_val106 {Type I LastRead 0 FirstWrite -1}
		qscale_5_val115 {Type I LastRead 0 FirstWrite -1}
		qscale_6_val123 {Type I LastRead 0 FirstWrite -1}
		qscale_7_val132 {Type I LastRead 0 FirstWrite -1}
		pout_local_0 {Type IO LastRead 20 FirstWrite 26}
		pout_local_1 {Type IO LastRead 20 FirstWrite 26}
		pout_local_2 {Type IO LastRead 20 FirstWrite 26}
		pout_local_3 {Type IO LastRead 20 FirstWrite 26}
		pout_local_4 {Type IO LastRead 20 FirstWrite 26}
		pout_local_5 {Type IO LastRead 20 FirstWrite 26}
		pout_local_6 {Type IO LastRead 20 FirstWrite 26}
		pout_local_7 {Type IO LastRead 20 FirstWrite 26}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac {
		xi_s_0_0 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_01 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_02 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_03 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_04 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_05 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_06 {Type I LastRead 1 FirstWrite -1}
		xi_s_0_07 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_08 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_09 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_010 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_011 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_012 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_013 {Type I LastRead 1 FirstWrite -1}
		mro_s_0_014 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val8 {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val16 {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val24 {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val32 {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val40 {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val48 {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val56 {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val64 {Type I LastRead 0 FirstWrite -1}
		qscale_0_val72 {Type I LastRead 0 FirstWrite -1}
		qscale_1_val81 {Type I LastRead 0 FirstWrite -1}
		qscale_2_val89 {Type I LastRead 0 FirstWrite -1}
		qscale_3_val98 {Type I LastRead 0 FirstWrite -1}
		qscale_4_val106 {Type I LastRead 0 FirstWrite -1}
		qscale_5_val115 {Type I LastRead 0 FirstWrite -1}
		qscale_6_val123 {Type I LastRead 0 FirstWrite -1}
		qscale_7_val132 {Type I LastRead 0 FirstWrite -1}
		pout_local_0 {Type IO LastRead 20 FirstWrite 26}
		pout_local_1 {Type IO LastRead 20 FirstWrite 26}
		pout_local_2 {Type IO LastRead 20 FirstWrite 26}
		pout_local_3 {Type IO LastRead 20 FirstWrite 26}
		pout_local_4 {Type IO LastRead 20 FirstWrite 26}
		pout_local_5 {Type IO LastRead 20 FirstWrite 26}
		pout_local_6 {Type IO LastRead 20 FirstWrite 26}
		pout_local_7 {Type IO LastRead 20 FirstWrite 26}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	compute_mac_sub {
		xi_s_0 {Type I LastRead 1 FirstWrite -1}
		mro_s_0 {Type I LastRead 1 FirstWrite -1}
		qzeros_0_val {Type I LastRead 0 FirstWrite -1}
		qzeros_1_val {Type I LastRead 0 FirstWrite -1}
		qzeros_2_val {Type I LastRead 0 FirstWrite -1}
		qzeros_3_val {Type I LastRead 0 FirstWrite -1}
		qzeros_4_val {Type I LastRead 0 FirstWrite -1}
		qzeros_5_val {Type I LastRead 0 FirstWrite -1}
		qzeros_6_val {Type I LastRead 0 FirstWrite -1}
		qzeros_7_val {Type I LastRead 0 FirstWrite -1}
		qscale_0_val {Type I LastRead 0 FirstWrite -1}
		qscale_1_val {Type I LastRead 0 FirstWrite -1}
		qscale_2_val {Type I LastRead 0 FirstWrite -1}
		qscale_3_val {Type I LastRead 0 FirstWrite -1}
		qscale_4_val {Type I LastRead 0 FirstWrite -1}
		qscale_5_val {Type I LastRead 0 FirstWrite -1}
		qscale_6_val {Type I LastRead 0 FirstWrite -1}
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2731", "Max" : "2731"}
	, {"Name" : "Interval", "Min" : "2731", "Max" : "2731"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	wide_trip_count { ap_fifo {  { wide_trip_count_dout fifo_data_in 0 16 }  { wide_trip_count_empty_n fifo_status 0 1 }  { wide_trip_count_read fifo_port_we 1 1 }  { wide_trip_count_num_data_valid fifo_status_num_data_valid 0 3 }  { wide_trip_count_fifo_cap fifo_update 0 3 } } }
	xi { ap_fifo {  { xi_dout fifo_data_in 0 128 }  { xi_empty_n fifo_status 0 1 }  { xi_read fifo_port_we 1 1 }  { xi_num_data_valid fifo_status_num_data_valid 0 3 }  { xi_fifo_cap fifo_update 0 3 } } }
	mro0 { ap_fifo {  { mro0_dout fifo_data_in 0 128 }  { mro0_empty_n fifo_status 0 1 }  { mro0_read fifo_port_we 1 1 }  { mro0_num_data_valid fifo_status_num_data_valid 0 3 }  { mro0_fifo_cap fifo_update 0 3 } } }
	mro1 { ap_fifo {  { mro1_dout fifo_data_in 0 128 }  { mro1_empty_n fifo_status 0 1 }  { mro1_read fifo_port_we 1 1 }  { mro1_num_data_valid fifo_status_num_data_valid 0 3 }  { mro1_fifo_cap fifo_update 0 3 } } }
	mro2 { ap_fifo {  { mro2_dout fifo_data_in 0 128 }  { mro2_empty_n fifo_status 0 1 }  { mro2_read fifo_port_we 1 1 }  { mro2_num_data_valid fifo_status_num_data_valid 0 3 }  { mro2_fifo_cap fifo_update 0 3 } } }
	mro3 { ap_fifo {  { mro3_dout fifo_data_in 0 128 }  { mro3_empty_n fifo_status 0 1 }  { mro3_read fifo_port_we 1 1 }  { mro3_num_data_valid fifo_status_num_data_valid 0 3 }  { mro3_fifo_cap fifo_update 0 3 } } }
	p_read { ap_none {  { p_read in_data 0 32 } } }
	p_read2 { ap_none {  { p_read2 in_data 0 32 } } }
	p_read6 { ap_none {  { p_read6 in_data 0 32 } } }
	p_read10 { ap_none {  { p_read10 in_data 0 32 } } }
	p_read14 { ap_none {  { p_read14 in_data 0 32 } } }
	p_read18 { ap_none {  { p_read18 in_data 0 32 } } }
	p_read22 { ap_none {  { p_read22 in_data 0 32 } } }
	p_read26 { ap_none {  { p_read26 in_data 0 32 } } }
	p_read30 { ap_none {  { p_read30 in_data 0 32 } } }
	p_read34 { ap_none {  { p_read34 in_data 0 32 } } }
	p_read38 { ap_none {  { p_read38 in_data 0 32 } } }
	p_read42 { ap_none {  { p_read42 in_data 0 32 } } }
	p_read46 { ap_none {  { p_read46 in_data 0 32 } } }
	p_read50 { ap_none {  { p_read50 in_data 0 32 } } }
	p_read54 { ap_none {  { p_read54 in_data 0 32 } } }
	p_read58 { ap_none {  { p_read58 in_data 0 32 } } }
	p_read62 { ap_none {  { p_read62 in_data 0 32 } } }
	p_read66 { ap_none {  { p_read66 in_data 0 32 } } }
	p_read70 { ap_none {  { p_read70 in_data 0 32 } } }
	p_read74 { ap_none {  { p_read74 in_data 0 32 } } }
	p_read78 { ap_none {  { p_read78 in_data 0 32 } } }
	p_read82 { ap_none {  { p_read82 in_data 0 32 } } }
	p_read86 { ap_none {  { p_read86 in_data 0 32 } } }
	p_read90 { ap_none {  { p_read90 in_data 0 32 } } }
	p_read94 { ap_none {  { p_read94 in_data 0 32 } } }
	p_read98 { ap_none {  { p_read98 in_data 0 32 } } }
	p_read102 { ap_none {  { p_read102 in_data 0 32 } } }
	p_read106 { ap_none {  { p_read106 in_data 0 32 } } }
	p_read110 { ap_none {  { p_read110 in_data 0 32 } } }
	p_read114 { ap_none {  { p_read114 in_data 0 32 } } }
	p_read118 { ap_none {  { p_read118 in_data 0 32 } } }
	p_read122 { ap_none {  { p_read122 in_data 0 32 } } }
}
