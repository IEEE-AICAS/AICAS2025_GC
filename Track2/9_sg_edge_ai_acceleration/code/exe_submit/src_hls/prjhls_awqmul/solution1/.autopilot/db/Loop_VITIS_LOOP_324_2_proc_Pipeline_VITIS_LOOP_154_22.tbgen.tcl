set moduleName Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22
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
set C_modelName {Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ p_0_0_3721_partselect int 32 regular  }
	{ p_0_0_2720_partselect int 32 regular  }
	{ p_0_0_1719_partselect int 32 regular  }
	{ empty int 32 regular  }
	{ mro1_s_M_elems_V_3 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_2 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_1 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_0 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_4 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_5 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_6 int 32 regular {fifo 1 volatile } {global 1}  }
	{ mro1_s_M_elems_V_7 int 32 regular {fifo 1 volatile } {global 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "p_0_0_3721_partselect", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_0_0_2720_partselect", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_0_0_1719_partselect", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro1_s_M_elems_V_3", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_4", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_5", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_6", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "mro1_s_M_elems_V_7", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} ]}
# RTL Port declarations: 
set portNum 34
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ mro1_s_M_elems_V_0_din sc_out sc_lv 32 signal 7 } 
	{ mro1_s_M_elems_V_0_full_n sc_in sc_logic 1 signal 7 } 
	{ mro1_s_M_elems_V_0_write sc_out sc_logic 1 signal 7 } 
	{ mro1_s_M_elems_V_4_din sc_out sc_lv 32 signal 8 } 
	{ mro1_s_M_elems_V_4_full_n sc_in sc_logic 1 signal 8 } 
	{ mro1_s_M_elems_V_4_write sc_out sc_logic 1 signal 8 } 
	{ mro1_s_M_elems_V_1_din sc_out sc_lv 32 signal 6 } 
	{ mro1_s_M_elems_V_1_full_n sc_in sc_logic 1 signal 6 } 
	{ mro1_s_M_elems_V_1_write sc_out sc_logic 1 signal 6 } 
	{ mro1_s_M_elems_V_5_din sc_out sc_lv 32 signal 9 } 
	{ mro1_s_M_elems_V_5_full_n sc_in sc_logic 1 signal 9 } 
	{ mro1_s_M_elems_V_5_write sc_out sc_logic 1 signal 9 } 
	{ mro1_s_M_elems_V_2_din sc_out sc_lv 32 signal 5 } 
	{ mro1_s_M_elems_V_2_full_n sc_in sc_logic 1 signal 5 } 
	{ mro1_s_M_elems_V_2_write sc_out sc_logic 1 signal 5 } 
	{ mro1_s_M_elems_V_6_din sc_out sc_lv 32 signal 10 } 
	{ mro1_s_M_elems_V_6_full_n sc_in sc_logic 1 signal 10 } 
	{ mro1_s_M_elems_V_6_write sc_out sc_logic 1 signal 10 } 
	{ mro1_s_M_elems_V_7_din sc_out sc_lv 32 signal 11 } 
	{ mro1_s_M_elems_V_7_full_n sc_in sc_logic 1 signal 11 } 
	{ mro1_s_M_elems_V_7_write sc_out sc_logic 1 signal 11 } 
	{ mro1_s_M_elems_V_3_din sc_out sc_lv 32 signal 4 } 
	{ mro1_s_M_elems_V_3_full_n sc_in sc_logic 1 signal 4 } 
	{ mro1_s_M_elems_V_3_write sc_out sc_logic 1 signal 4 } 
	{ p_0_0_3721_partselect sc_in sc_lv 32 signal 0 } 
	{ p_0_0_2720_partselect sc_in sc_lv 32 signal 1 } 
	{ p_0_0_1719_partselect sc_in sc_lv 32 signal 2 } 
	{ empty sc_in sc_lv 32 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "mro1_s_M_elems_V_0_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_0", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_0_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_0", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_0_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_0", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_4", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_4", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_4", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_1", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_1", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_1", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_5", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_5", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_5", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_2_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_2", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_2_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_2", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_2_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_2", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_6", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_6", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_6", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_7_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_7", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_7_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_7", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_7_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_7", "role": "write" }} , 
 	{ "name": "mro1_s_M_elems_V_3_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_3", "role": "din" }} , 
 	{ "name": "mro1_s_M_elems_V_3_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_3", "role": "full_n" }} , 
 	{ "name": "mro1_s_M_elems_V_3_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_s_M_elems_V_3", "role": "write" }} , 
 	{ "name": "p_0_0_3721_partselect", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_0_0_3721_partselect", "role": "default" }} , 
 	{ "name": "p_0_0_2720_partselect", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_0_0_2720_partselect", "role": "default" }} , 
 	{ "name": "p_0_0_1719_partselect", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_0_0_1719_partselect", "role": "default" }} , 
 	{ "name": "empty", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
		mro1_s_M_elems_V_7 {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "18", "Max" : "18"}
	, {"Name" : "Interval", "Min" : "18", "Max" : "18"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_0_0_3721_partselect { ap_none {  { p_0_0_3721_partselect in_data 0 32 } } }
	p_0_0_2720_partselect { ap_none {  { p_0_0_2720_partselect in_data 0 32 } } }
	p_0_0_1719_partselect { ap_none {  { p_0_0_1719_partselect in_data 0 32 } } }
	empty { ap_none {  { empty in_data 0 32 } } }
	mro1_s_M_elems_V_3 { ap_fifo {  { mro1_s_M_elems_V_3_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_3_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_3_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_2 { ap_fifo {  { mro1_s_M_elems_V_2_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_2_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_2_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_1 { ap_fifo {  { mro1_s_M_elems_V_1_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_1_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_1_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_0 { ap_fifo {  { mro1_s_M_elems_V_0_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_0_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_0_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_4 { ap_fifo {  { mro1_s_M_elems_V_4_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_4_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_4_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_5 { ap_fifo {  { mro1_s_M_elems_V_5_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_5_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_5_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_6 { ap_fifo {  { mro1_s_M_elems_V_6_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_6_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_6_write fifo_port_we 1 1 } } }
	mro1_s_M_elems_V_7 { ap_fifo {  { mro1_s_M_elems_V_7_din fifo_data_in 1 32 }  { mro1_s_M_elems_V_7_full_n fifo_status 0 1 }  { mro1_s_M_elems_V_7_write fifo_port_we 1 1 } } }
}
