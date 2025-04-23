set moduleName compute_mac_sub
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type loop_auto_rewind
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
set C_modelName {compute_mac_sub}
set C_modelType { int 256 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ xi_s_0 float 32 regular {fifo 0 volatile }  }
	{ mro_s_0 int 32 regular {fifo 0 volatile }  }
	{ qzeros_0_val int 4 regular  }
	{ qzeros_1_val int 4 regular  }
	{ qzeros_2_val int 4 regular  }
	{ qzeros_3_val int 4 regular  }
	{ qzeros_4_val int 4 regular  }
	{ qzeros_5_val int 4 regular  }
	{ qzeros_6_val int 4 regular  }
	{ qzeros_7_val int 4 regular  }
	{ qscale_0_val float 32 regular  }
	{ qscale_1_val float 32 regular  }
	{ qscale_2_val float 32 regular  }
	{ qscale_3_val float 32 regular  }
	{ qscale_4_val float 32 regular  }
	{ qscale_5_val float 32 regular  }
	{ qscale_6_val float 32 regular  }
	{ qscale_7_val float 32 regular  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "xi_s_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_0_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_1_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_2_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_3_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_4_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_5_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_6_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_7_val", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_0_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_1_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_2_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_3_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_4_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_5_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_6_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_7_val", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "ap_return", "interface" : "wire", "bitwidth" : 256} ]}
# RTL Port declarations: 
set portNum 36
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ xi_s_0_dout sc_in sc_lv 32 signal 0 } 
	{ xi_s_0_empty_n sc_in sc_logic 1 signal 0 } 
	{ xi_s_0_read sc_out sc_logic 1 signal 0 } 
	{ mro_s_0_dout sc_in sc_lv 32 signal 1 } 
	{ mro_s_0_empty_n sc_in sc_logic 1 signal 1 } 
	{ mro_s_0_read sc_out sc_logic 1 signal 1 } 
	{ qzeros_0_val sc_in sc_lv 4 signal 2 } 
	{ qzeros_1_val sc_in sc_lv 4 signal 3 } 
	{ qzeros_2_val sc_in sc_lv 4 signal 4 } 
	{ qzeros_3_val sc_in sc_lv 4 signal 5 } 
	{ qzeros_4_val sc_in sc_lv 4 signal 6 } 
	{ qzeros_5_val sc_in sc_lv 4 signal 7 } 
	{ qzeros_6_val sc_in sc_lv 4 signal 8 } 
	{ qzeros_7_val sc_in sc_lv 4 signal 9 } 
	{ qscale_0_val sc_in sc_lv 32 signal 10 } 
	{ qscale_1_val sc_in sc_lv 32 signal 11 } 
	{ qscale_2_val sc_in sc_lv 32 signal 12 } 
	{ qscale_3_val sc_in sc_lv 32 signal 13 } 
	{ qscale_4_val sc_in sc_lv 32 signal 14 } 
	{ qscale_5_val sc_in sc_lv 32 signal 15 } 
	{ qscale_6_val sc_in sc_lv 32 signal 16 } 
	{ qscale_7_val sc_in sc_lv 32 signal 17 } 
	{ ap_return_0 sc_out sc_lv 32 signal -1 } 
	{ ap_return_1 sc_out sc_lv 32 signal -1 } 
	{ ap_return_2 sc_out sc_lv 32 signal -1 } 
	{ ap_return_3 sc_out sc_lv 32 signal -1 } 
	{ ap_return_4 sc_out sc_lv 32 signal -1 } 
	{ ap_return_5 sc_out sc_lv 32 signal -1 } 
	{ ap_return_6 sc_out sc_lv 32 signal -1 } 
	{ ap_return_7 sc_out sc_lv 32 signal -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "xi_s_0_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0", "role": "dout" }} , 
 	{ "name": "xi_s_0_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0", "role": "read" }} , 
 	{ "name": "mro_s_0_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0", "role": "dout" }} , 
 	{ "name": "mro_s_0_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0", "role": "read" }} , 
 	{ "name": "qzeros_0_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_0_val", "role": "default" }} , 
 	{ "name": "qzeros_1_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_1_val", "role": "default" }} , 
 	{ "name": "qzeros_2_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_2_val", "role": "default" }} , 
 	{ "name": "qzeros_3_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_3_val", "role": "default" }} , 
 	{ "name": "qzeros_4_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_4_val", "role": "default" }} , 
 	{ "name": "qzeros_5_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_5_val", "role": "default" }} , 
 	{ "name": "qzeros_6_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_6_val", "role": "default" }} , 
 	{ "name": "qzeros_7_val", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_7_val", "role": "default" }} , 
 	{ "name": "qscale_0_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_0_val", "role": "default" }} , 
 	{ "name": "qscale_1_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_1_val", "role": "default" }} , 
 	{ "name": "qscale_2_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_2_val", "role": "default" }} , 
 	{ "name": "qscale_3_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_3_val", "role": "default" }} , 
 	{ "name": "qscale_4_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_4_val", "role": "default" }} , 
 	{ "name": "qscale_5_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_5_val", "role": "default" }} , 
 	{ "name": "qscale_6_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_6_val", "role": "default" }} , 
 	{ "name": "qscale_7_val", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_7_val", "role": "default" }} , 
 	{ "name": "ap_return_0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_0", "role": "default" }} , 
 	{ "name": "ap_return_1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_1", "role": "default" }} , 
 	{ "name": "ap_return_2", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_2", "role": "default" }} , 
 	{ "name": "ap_return_3", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_3", "role": "default" }} , 
 	{ "name": "ap_return_4", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_4", "role": "default" }} , 
 	{ "name": "ap_return_5", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_5", "role": "default" }} , 
 	{ "name": "ap_return_6", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_6", "role": "default" }} , 
 	{ "name": "ap_return_7", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return_7", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "59", "Max" : "59"}
	, {"Name" : "Interval", "Min" : "59", "Max" : "59"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	xi_s_0 { ap_fifo {  { xi_s_0_dout fifo_data_in 0 32 }  { xi_s_0_empty_n fifo_status 0 1 }  { xi_s_0_read fifo_port_we 1 1 } } }
	mro_s_0 { ap_fifo {  { mro_s_0_dout fifo_data_in 0 32 }  { mro_s_0_empty_n fifo_status 0 1 }  { mro_s_0_read fifo_port_we 1 1 } } }
	qzeros_0_val { ap_none {  { qzeros_0_val in_data 0 4 } } }
	qzeros_1_val { ap_none {  { qzeros_1_val in_data 0 4 } } }
	qzeros_2_val { ap_none {  { qzeros_2_val in_data 0 4 } } }
	qzeros_3_val { ap_none {  { qzeros_3_val in_data 0 4 } } }
	qzeros_4_val { ap_none {  { qzeros_4_val in_data 0 4 } } }
	qzeros_5_val { ap_none {  { qzeros_5_val in_data 0 4 } } }
	qzeros_6_val { ap_none {  { qzeros_6_val in_data 0 4 } } }
	qzeros_7_val { ap_none {  { qzeros_7_val in_data 0 4 } } }
	qscale_0_val { ap_none {  { qscale_0_val in_data 0 32 } } }
	qscale_1_val { ap_none {  { qscale_1_val in_data 0 32 } } }
	qscale_2_val { ap_none {  { qscale_2_val in_data 0 32 } } }
	qscale_3_val { ap_none {  { qscale_3_val in_data 0 32 } } }
	qscale_4_val { ap_none {  { qscale_4_val in_data 0 32 } } }
	qscale_5_val { ap_none {  { qscale_5_val in_data 0 32 } } }
	qscale_6_val { ap_none {  { qscale_6_val in_data 0 32 } } }
	qscale_7_val { ap_none {  { qscale_7_val in_data 0 32 } } }
}
