set moduleName entry_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 1
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 17
set C_modelName {entry_proc}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ xi int 128 regular {pointer 0}  }
	{ xi_c int 128 regular {fifo 1}  }
	{ mro0 int 128 regular {pointer 0}  }
	{ mro0_c int 128 regular {fifo 1}  }
	{ mro1 int 128 regular {pointer 0}  }
	{ mro1_c int 128 regular {fifo 1}  }
	{ mro2 int 128 regular {pointer 0}  }
	{ mro2_c int 128 regular {fifo 1}  }
	{ mro3 int 128 regular {pointer 0}  }
	{ mro3_c int 128 regular {fifo 1}  }
	{ row int 16 regular  }
	{ row_c int 16 regular {fifo 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "xi", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "xi_c", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "mro0", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro0_c", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "mro1", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro1_c", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "mro2", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro2_c", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "mro3", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro3_c", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "row", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "row_c", "interface" : "fifo", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 46
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ xi sc_in sc_lv 128 signal 0 } 
	{ xi_c_din sc_out sc_lv 128 signal 1 } 
	{ xi_c_full_n sc_in sc_logic 1 signal 1 } 
	{ xi_c_write sc_out sc_logic 1 signal 1 } 
	{ xi_c_num_data_valid sc_in sc_lv 3 signal 1 } 
	{ xi_c_fifo_cap sc_in sc_lv 3 signal 1 } 
	{ mro0 sc_in sc_lv 128 signal 2 } 
	{ mro0_c_din sc_out sc_lv 128 signal 3 } 
	{ mro0_c_full_n sc_in sc_logic 1 signal 3 } 
	{ mro0_c_write sc_out sc_logic 1 signal 3 } 
	{ mro0_c_num_data_valid sc_in sc_lv 3 signal 3 } 
	{ mro0_c_fifo_cap sc_in sc_lv 3 signal 3 } 
	{ mro1 sc_in sc_lv 128 signal 4 } 
	{ mro1_c_din sc_out sc_lv 128 signal 5 } 
	{ mro1_c_full_n sc_in sc_logic 1 signal 5 } 
	{ mro1_c_write sc_out sc_logic 1 signal 5 } 
	{ mro1_c_num_data_valid sc_in sc_lv 3 signal 5 } 
	{ mro1_c_fifo_cap sc_in sc_lv 3 signal 5 } 
	{ mro2 sc_in sc_lv 128 signal 6 } 
	{ mro2_c_din sc_out sc_lv 128 signal 7 } 
	{ mro2_c_full_n sc_in sc_logic 1 signal 7 } 
	{ mro2_c_write sc_out sc_logic 1 signal 7 } 
	{ mro2_c_num_data_valid sc_in sc_lv 3 signal 7 } 
	{ mro2_c_fifo_cap sc_in sc_lv 3 signal 7 } 
	{ mro3 sc_in sc_lv 128 signal 8 } 
	{ mro3_c_din sc_out sc_lv 128 signal 9 } 
	{ mro3_c_full_n sc_in sc_logic 1 signal 9 } 
	{ mro3_c_write sc_out sc_logic 1 signal 9 } 
	{ mro3_c_num_data_valid sc_in sc_lv 3 signal 9 } 
	{ mro3_c_fifo_cap sc_in sc_lv 3 signal 9 } 
	{ row sc_in sc_lv 16 signal 10 } 
	{ row_c_din sc_out sc_lv 16 signal 11 } 
	{ row_c_full_n sc_in sc_logic 1 signal 11 } 
	{ row_c_write sc_out sc_logic 1 signal 11 } 
	{ row_c_num_data_valid sc_in sc_lv 3 signal 11 } 
	{ row_c_fifo_cap sc_in sc_lv 3 signal 11 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "xi", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "xi", "role": "default" }} , 
 	{ "name": "xi_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "xi_c", "role": "din" }} , 
 	{ "name": "xi_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_c", "role": "full_n" }} , 
 	{ "name": "xi_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_c", "role": "write" }} , 
 	{ "name": "xi_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "xi_c", "role": "num_data_valid" }} , 
 	{ "name": "xi_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "xi_c", "role": "fifo_cap" }} , 
 	{ "name": "mro0", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro0", "role": "default" }} , 
 	{ "name": "mro0_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro0_c", "role": "din" }} , 
 	{ "name": "mro0_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro0_c", "role": "full_n" }} , 
 	{ "name": "mro0_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro0_c", "role": "write" }} , 
 	{ "name": "mro0_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro0_c", "role": "num_data_valid" }} , 
 	{ "name": "mro0_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro0_c", "role": "fifo_cap" }} , 
 	{ "name": "mro1", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro1", "role": "default" }} , 
 	{ "name": "mro1_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro1_c", "role": "din" }} , 
 	{ "name": "mro1_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_c", "role": "full_n" }} , 
 	{ "name": "mro1_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro1_c", "role": "write" }} , 
 	{ "name": "mro1_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro1_c", "role": "num_data_valid" }} , 
 	{ "name": "mro1_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro1_c", "role": "fifo_cap" }} , 
 	{ "name": "mro2", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro2", "role": "default" }} , 
 	{ "name": "mro2_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro2_c", "role": "din" }} , 
 	{ "name": "mro2_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro2_c", "role": "full_n" }} , 
 	{ "name": "mro2_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro2_c", "role": "write" }} , 
 	{ "name": "mro2_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro2_c", "role": "num_data_valid" }} , 
 	{ "name": "mro2_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro2_c", "role": "fifo_cap" }} , 
 	{ "name": "mro3", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro3", "role": "default" }} , 
 	{ "name": "mro3_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro3_c", "role": "din" }} , 
 	{ "name": "mro3_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro3_c", "role": "full_n" }} , 
 	{ "name": "mro3_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro3_c", "role": "write" }} , 
 	{ "name": "mro3_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro3_c", "role": "num_data_valid" }} , 
 	{ "name": "mro3_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "mro3_c", "role": "fifo_cap" }} , 
 	{ "name": "row", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "row", "role": "default" }} , 
 	{ "name": "row_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "row_c", "role": "din" }} , 
 	{ "name": "row_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "row_c", "role": "full_n" }} , 
 	{ "name": "row_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "row_c", "role": "write" }} , 
 	{ "name": "row_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "row_c", "role": "num_data_valid" }} , 
 	{ "name": "row_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "row_c", "role": "fifo_cap" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "entry_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "xi", "Type" : "None", "Direction" : "I"},
			{"Name" : "xi_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "xi_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro0_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro0_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro1_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro1_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro2_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro2_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro3_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro3_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "row", "Type" : "None", "Direction" : "I"},
			{"Name" : "row_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "row_c_blk_n", "Type" : "RtlSignal"}]}]}]}


set ArgLastReadFirstWriteLatency {
	entry_proc {
		xi {Type I LastRead 0 FirstWrite -1}
		xi_c {Type O LastRead -1 FirstWrite 0}
		mro0 {Type I LastRead 0 FirstWrite -1}
		mro0_c {Type O LastRead -1 FirstWrite 0}
		mro1 {Type I LastRead 0 FirstWrite -1}
		mro1_c {Type O LastRead -1 FirstWrite 0}
		mro2 {Type I LastRead 0 FirstWrite -1}
		mro2_c {Type O LastRead -1 FirstWrite 0}
		mro3 {Type I LastRead 0 FirstWrite -1}
		mro3_c {Type O LastRead -1 FirstWrite 0}
		row {Type I LastRead 0 FirstWrite -1}
		row_c {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "0", "Max" : "0"}
	, {"Name" : "Interval", "Min" : "0", "Max" : "0"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	xi { ap_none {  { xi in_data 0 128 } } }
	xi_c { ap_fifo {  { xi_c_din fifo_data_in 1 128 }  { xi_c_full_n fifo_status 0 1 }  { xi_c_write fifo_port_we 1 1 }  { xi_c_num_data_valid fifo_status_num_data_valid 0 3 }  { xi_c_fifo_cap fifo_update 0 3 } } }
	mro0 { ap_none {  { mro0 in_data 0 128 } } }
	mro0_c { ap_fifo {  { mro0_c_din fifo_data_in 1 128 }  { mro0_c_full_n fifo_status 0 1 }  { mro0_c_write fifo_port_we 1 1 }  { mro0_c_num_data_valid fifo_status_num_data_valid 0 3 }  { mro0_c_fifo_cap fifo_update 0 3 } } }
	mro1 { ap_none {  { mro1 in_data 0 128 } } }
	mro1_c { ap_fifo {  { mro1_c_din fifo_data_in 1 128 }  { mro1_c_full_n fifo_status 0 1 }  { mro1_c_write fifo_port_we 1 1 }  { mro1_c_num_data_valid fifo_status_num_data_valid 0 3 }  { mro1_c_fifo_cap fifo_update 0 3 } } }
	mro2 { ap_none {  { mro2 in_data 0 128 } } }
	mro2_c { ap_fifo {  { mro2_c_din fifo_data_in 1 128 }  { mro2_c_full_n fifo_status 0 1 }  { mro2_c_write fifo_port_we 1 1 }  { mro2_c_num_data_valid fifo_status_num_data_valid 0 3 }  { mro2_c_fifo_cap fifo_update 0 3 } } }
	mro3 { ap_none {  { mro3 in_data 0 128 } } }
	mro3_c { ap_fifo {  { mro3_c_din fifo_data_in 1 128 }  { mro3_c_full_n fifo_status 0 1 }  { mro3_c_write fifo_port_we 1 1 }  { mro3_c_num_data_valid fifo_status_num_data_valid 0 3 }  { mro3_c_fifo_cap fifo_update 0 3 } } }
	row { ap_none {  { row in_data 0 16 } } }
	row_c { ap_fifo {  { row_c_din fifo_data_in 1 16 }  { row_c_full_n fifo_status 0 1 }  { row_c_write fifo_port_we 1 1 }  { row_c_num_data_valid fifo_status_num_data_valid 0 3 }  { row_c_fifo_cap fifo_update 0 3 } } }
}
