set moduleName Macro_MAC_Acc4_top
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
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
set C_modelName {Macro_MAC_Acc4_top}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ out_r int 128 regular {pointer 1}  }
	{ xi int 128 regular {pointer 0}  }
	{ mro0 int 128 regular {pointer 0}  }
	{ mro1 int 128 regular {pointer 0}  }
	{ mro2 int 128 regular {pointer 0}  }
	{ mro3 int 128 regular {pointer 0}  }
	{ row uint 16 regular  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "out_r", "interface" : "wire", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "xi", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro0", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro1", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro2", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "mro3", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "row", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 14
set portList { 
	{ out_r sc_out sc_lv 128 signal 0 } 
	{ xi sc_in sc_lv 128 signal 1 } 
	{ mro0 sc_in sc_lv 128 signal 2 } 
	{ mro1 sc_in sc_lv 128 signal 3 } 
	{ mro2 sc_in sc_lv 128 signal 4 } 
	{ mro3 sc_in sc_lv 128 signal 5 } 
	{ row sc_in sc_lv 16 signal 6 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ out_r_ap_vld sc_out sc_logic 1 outvld 0 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
}
set NewPortList {[ 
	{ "name": "out_r", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "out_r", "role": "default" }} , 
 	{ "name": "xi", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "xi", "role": "default" }} , 
 	{ "name": "mro0", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro0", "role": "default" }} , 
 	{ "name": "mro1", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro1", "role": "default" }} , 
 	{ "name": "mro2", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro2", "role": "default" }} , 
 	{ "name": "mro3", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "mro3", "role": "default" }} , 
 	{ "name": "row", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "row", "role": "default" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "out_r_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_r", "role": "ap_vld" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "477", "479", "480", "481", "482", "483", "484", "485", "486", "487", "488", "489", "490", "491", "492", "493", "494", "495", "496", "497", "498", "499", "500", "501", "502", "503", "504", "505", "506", "507", "508", "509", "510", "511", "512", "513", "514", "515", "516", "517"],
		"CDFG" : "Macro_MAC_Acc4_top",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2742", "EstimateLatencyMax" : "2742",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "1", "Name" : "entry_proc_U0"}],
		"OutputProcess" : [
			{"ID" : "477", "Name" : "Loop_VITIS_LOOP_337_3_proc_U0"}],
		"Port" : [
			{"Name" : "out_r", "Type" : "Vld", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "477", "SubInstance" : "Loop_VITIS_LOOP_337_3_proc_U0", "Port" : "out_r"}]},
			{"Name" : "xi", "Type" : "None", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "entry_proc_U0", "Port" : "xi"}]},
			{"Name" : "mro0", "Type" : "None", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "entry_proc_U0", "Port" : "mro0"}]},
			{"Name" : "mro1", "Type" : "None", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "entry_proc_U0", "Port" : "mro1"}]},
			{"Name" : "mro2", "Type" : "None", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "entry_proc_U0", "Port" : "mro2"}]},
			{"Name" : "mro3", "Type" : "None", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "entry_proc_U0", "Port" : "mro3"}]},
			{"Name" : "row", "Type" : "None", "Direction" : "I"},
			{"Name" : "xi3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_2"}]},
			{"Name" : "xi3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_6"}]},
			{"Name" : "xi3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_1"}]},
			{"Name" : "xi3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_5"}]},
			{"Name" : "xi3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_0"}]},
			{"Name" : "xi3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_4"}]},
			{"Name" : "xi2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_2"}]},
			{"Name" : "xi2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_6"}]},
			{"Name" : "xi2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_1"}]},
			{"Name" : "xi2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_5"}]},
			{"Name" : "xi2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_0"}]},
			{"Name" : "xi2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_4"}]},
			{"Name" : "xi1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_2"}]},
			{"Name" : "xi1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_6"}]},
			{"Name" : "xi1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_1"}]},
			{"Name" : "xi1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_5"}]},
			{"Name" : "xi1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_0"}]},
			{"Name" : "xi1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_4"}]},
			{"Name" : "xi0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_3"}]},
			{"Name" : "xi1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_3"}]},
			{"Name" : "xi2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_3"}]},
			{"Name" : "xi3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_3"}]},
			{"Name" : "xi0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_7"}]},
			{"Name" : "xi1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi1_s_M_elems_V_7"}]},
			{"Name" : "xi2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi2_s_M_elems_V_7"}]},
			{"Name" : "xi3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi3_s_M_elems_V_7"}]},
			{"Name" : "xi0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_2"}]},
			{"Name" : "xi0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_6"}]},
			{"Name" : "xi0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_1"}]},
			{"Name" : "xi0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_5"}]},
			{"Name" : "xi0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_0"}]},
			{"Name" : "xi0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "xi0_s_M_elems_V_4"}]},
			{"Name" : "mro0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_3"}]},
			{"Name" : "mro0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_2"}]},
			{"Name" : "mro0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_1"}]},
			{"Name" : "mro0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_0"}]},
			{"Name" : "mro0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_4"}]},
			{"Name" : "mro0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_5"}]},
			{"Name" : "mro0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_6"}]},
			{"Name" : "mro0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro0_s_M_elems_V_7"}]},
			{"Name" : "mro1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_3"}]},
			{"Name" : "mro1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_2"}]},
			{"Name" : "mro1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_1"}]},
			{"Name" : "mro1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_0"}]},
			{"Name" : "mro1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_4"}]},
			{"Name" : "mro1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_5"}]},
			{"Name" : "mro1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_6"}]},
			{"Name" : "mro1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro1_s_M_elems_V_7"}]},
			{"Name" : "mro2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_3"}]},
			{"Name" : "mro2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_2"}]},
			{"Name" : "mro2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_1"}]},
			{"Name" : "mro2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_0"}]},
			{"Name" : "mro2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_4"}]},
			{"Name" : "mro2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_5"}]},
			{"Name" : "mro2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_6"}]},
			{"Name" : "mro2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro2_s_M_elems_V_7"}]},
			{"Name" : "mro3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_3"}]},
			{"Name" : "mro3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_2"}]},
			{"Name" : "mro3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_1"}]},
			{"Name" : "mro3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_0"}]},
			{"Name" : "mro3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_4"}]},
			{"Name" : "mro3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_5"}]},
			{"Name" : "mro3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_6"}]},
			{"Name" : "mro3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "Loop_VITIS_LOOP_324_2_proc_U0", "Port" : "mro3_s_M_elems_V_7"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.entry_proc_U0", "Parent" : "0",
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
			{"Name" : "xi_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "479", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "xi_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro0_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "480", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro0_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro1_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "481", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro1_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro2_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "482", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro2_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3", "Type" : "None", "Direction" : "I"},
			{"Name" : "mro3_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "483", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro3_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "row", "Type" : "None", "Direction" : "I"},
			{"Name" : "row_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["2"], "DependentChan" : "484", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "row_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0", "Parent" : "0", "Child" : ["3", "5", "7", "9", "11", "13", "15", "17", "19", "21", "119", "217", "315", "413", "414", "415", "416", "417", "418", "419", "420", "421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432", "433", "434", "435", "436", "437", "438", "439", "440", "441", "442", "443", "444", "445", "446", "447", "448", "449", "450", "451", "452", "453", "454", "455", "456", "457", "458", "459", "460", "461", "462", "463", "464", "465", "466", "467", "468", "469", "470", "471", "472", "473", "474", "475", "476"],
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
		"StartSource" : "1",
		"StartFifo" : "start_for_Loop_VITIS_LOOP_324_2_proc_U0_U",
		"Port" : [
			{"Name" : "wide_trip_count", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "484", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "wide_trip_count_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "xi", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "479", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "xi_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro0", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "480", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro0_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "481", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro1_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro2", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "482", "DependentChanDepth" : "3", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mro2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mro3", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "483", "DependentChanDepth" : "3", "DependentChanType" : "2",
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
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_3", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_03", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi1_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi2_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi3_s_M_elems_V_7", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "xi_s_0_07", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_2", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_02", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_6", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_06", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_1", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_01", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_5", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_05", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_0", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "xi0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_read_xi_to_stream_fu_1054", "Port" : "xi0_s_M_elems_V_4", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "xi_s_0_04", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_3", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_2", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_1", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_0", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_4", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_5", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_6", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro0_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Port" : "mro0_s_M_elems_V_7", "Inst_start_state" : "4", "Inst_end_state" : "5"},
					{"ID" : "21", "SubInstance" : "grp_compute_mac_fu_1299", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_3", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_2", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_1", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_0", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_4", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_5", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_6", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro1_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Port" : "mro1_s_M_elems_V_7", "Inst_start_state" : "6", "Inst_end_state" : "7"},
					{"ID" : "119", "SubInstance" : "grp_compute_mac_fu_1359", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_3", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_2", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_1", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_0", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_4", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_5", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_6", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro2_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Port" : "mro2_s_M_elems_V_7", "Inst_start_state" : "8", "Inst_end_state" : "9"},
					{"ID" : "217", "SubInstance" : "grp_compute_mac_fu_1419", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_3", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_3", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_010", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_2", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_2", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_09", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_1", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_1", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_08", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_0", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_0", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_0", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_4", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_4", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_011", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_5", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_5", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_012", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_6", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_6", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_013", "Inst_start_state" : "12", "Inst_end_state" : "13"}]},
			{"Name" : "mro3_s_M_elems_V_7", "Type" : "Fifo", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "19", "SubInstance" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Port" : "mro3_s_M_elems_V_7", "Inst_start_state" : "10", "Inst_end_state" : "11"},
					{"ID" : "315", "SubInstance" : "grp_compute_mac_fu_1479", "Port" : "mro_s_0_014", "Inst_start_state" : "12", "Inst_end_state" : "13"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_324_2", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "13", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state13"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_read_xi_to_stream_fu_1054", "Parent" : "2", "Child" : ["4"],
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
	{"ID" : "4", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_read_xi_to_stream_fu_1054.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1_fu_1123", "Parent" : "2", "Child" : ["6"],
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
	{"ID" : "6", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1_fu_1123.flow_control_loop_pipe_sequential_init_U", "Parent" : "5"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11_fu_1143", "Parent" : "2", "Child" : ["8"],
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
	{"ID" : "8", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11_fu_1143.flow_control_loop_pipe_sequential_init_U", "Parent" : "7"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13_fu_1163", "Parent" : "2", "Child" : ["10"],
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
	{"ID" : "10", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13_fu_1163.flow_control_loop_pipe_sequential_init_U", "Parent" : "9"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15_fu_1183", "Parent" : "2", "Child" : ["12"],
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
	{"ID" : "12", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15_fu_1183.flow_control_loop_pipe_sequential_init_U", "Parent" : "11"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203", "Parent" : "2", "Child" : ["14"],
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
	{"ID" : "14", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203.flow_control_loop_pipe_sequential_init_U", "Parent" : "13"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227", "Parent" : "2", "Child" : ["16"],
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
	{"ID" : "16", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227.flow_control_loop_pipe_sequential_init_U", "Parent" : "15"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251", "Parent" : "2", "Child" : ["18"],
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
	{"ID" : "18", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251.flow_control_loop_pipe_sequential_init_U", "Parent" : "17"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275", "Parent" : "2", "Child" : ["20"],
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
	{"ID" : "20", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275.flow_control_loop_pipe_sequential_init_U", "Parent" : "19"},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299", "Parent" : "2", "Child" : ["22", "32", "42", "52", "62", "72", "82", "92", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118"],
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
					{"ID" : "22", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "32", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "42", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "62", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "72", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "92", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "22", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "32", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "42", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "62", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "72", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "92", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
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
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360", "Parent" : "21", "Child" : ["23", "24", "25", "26", "27", "28", "29", "30", "31"],
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
	{"ID" : "23", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "22"},
	{"ID" : "24", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "22"},
	{"ID" : "25", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "22"},
	{"ID" : "26", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "22"},
	{"ID" : "27", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "22"},
	{"ID" : "28", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "22"},
	{"ID" : "29", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "22"},
	{"ID" : "30", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "22"},
	{"ID" : "31", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "22"},
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400", "Parent" : "21", "Child" : ["33", "34", "35", "36", "37", "38", "39", "40", "41"],
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
	{"ID" : "33", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "32"},
	{"ID" : "34", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "32"},
	{"ID" : "35", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "32"},
	{"ID" : "36", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "32"},
	{"ID" : "37", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "32"},
	{"ID" : "38", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "32"},
	{"ID" : "39", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "32"},
	{"ID" : "40", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "32"},
	{"ID" : "41", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "32"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440", "Parent" : "21", "Child" : ["43", "44", "45", "46", "47", "48", "49", "50", "51"],
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
	{"ID" : "43", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "42"},
	{"ID" : "44", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "42"},
	{"ID" : "45", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "42"},
	{"ID" : "46", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "42"},
	{"ID" : "47", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "42"},
	{"ID" : "48", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "42"},
	{"ID" : "49", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "42"},
	{"ID" : "50", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "42"},
	{"ID" : "51", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "42"},
	{"ID" : "52", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480", "Parent" : "21", "Child" : ["53", "54", "55", "56", "57", "58", "59", "60", "61"],
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
	{"ID" : "53", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "52"},
	{"ID" : "54", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "52"},
	{"ID" : "55", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "52"},
	{"ID" : "56", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "52"},
	{"ID" : "57", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "52"},
	{"ID" : "58", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "52"},
	{"ID" : "59", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "52"},
	{"ID" : "60", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "52"},
	{"ID" : "61", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "52"},
	{"ID" : "62", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520", "Parent" : "21", "Child" : ["63", "64", "65", "66", "67", "68", "69", "70", "71"],
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
	{"ID" : "63", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "62"},
	{"ID" : "64", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "62"},
	{"ID" : "65", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "62"},
	{"ID" : "66", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "62"},
	{"ID" : "67", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "62"},
	{"ID" : "68", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "62"},
	{"ID" : "69", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "62"},
	{"ID" : "70", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "62"},
	{"ID" : "71", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "62"},
	{"ID" : "72", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560", "Parent" : "21", "Child" : ["73", "74", "75", "76", "77", "78", "79", "80", "81"],
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
	{"ID" : "73", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "72"},
	{"ID" : "74", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "72"},
	{"ID" : "75", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "72"},
	{"ID" : "76", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "72"},
	{"ID" : "77", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "72"},
	{"ID" : "78", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "72"},
	{"ID" : "79", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "72"},
	{"ID" : "80", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "72"},
	{"ID" : "81", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "72"},
	{"ID" : "82", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600", "Parent" : "21", "Child" : ["83", "84", "85", "86", "87", "88", "89", "90", "91"],
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
	{"ID" : "83", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "82"},
	{"ID" : "84", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "82"},
	{"ID" : "85", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "82"},
	{"ID" : "86", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "82"},
	{"ID" : "87", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "82"},
	{"ID" : "88", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "82"},
	{"ID" : "89", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "82"},
	{"ID" : "90", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "82"},
	{"ID" : "91", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "82"},
	{"ID" : "92", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640", "Parent" : "21", "Child" : ["93", "94", "95", "96", "97", "98", "99", "100", "101"],
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
	{"ID" : "93", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "92"},
	{"ID" : "94", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "92"},
	{"ID" : "95", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "92"},
	{"ID" : "96", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "92"},
	{"ID" : "97", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "92"},
	{"ID" : "98", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "92"},
	{"ID" : "99", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "92"},
	{"ID" : "100", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "92"},
	{"ID" : "101", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "92"},
	{"ID" : "102", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "21"},
	{"ID" : "103", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "21"},
	{"ID" : "104", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "21"},
	{"ID" : "105", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "21"},
	{"ID" : "106", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "21"},
	{"ID" : "107", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "21"},
	{"ID" : "108", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "21"},
	{"ID" : "109", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "21"},
	{"ID" : "110", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U195", "Parent" : "21"},
	{"ID" : "111", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U196", "Parent" : "21"},
	{"ID" : "112", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U197", "Parent" : "21"},
	{"ID" : "113", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U198", "Parent" : "21"},
	{"ID" : "114", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U199", "Parent" : "21"},
	{"ID" : "115", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U200", "Parent" : "21"},
	{"ID" : "116", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U201", "Parent" : "21"},
	{"ID" : "117", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U202", "Parent" : "21"},
	{"ID" : "118", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1299.sparsemux_17_3_32_1_1_U203", "Parent" : "21"},
	{"ID" : "119", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359", "Parent" : "2", "Child" : ["120", "130", "140", "150", "160", "170", "180", "190", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216"],
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
					{"ID" : "120", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "130", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "140", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "150", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "160", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "170", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "180", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "190", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "120", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "130", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "140", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "150", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "160", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "170", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "180", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "190", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
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
	{"ID" : "120", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360", "Parent" : "119", "Child" : ["121", "122", "123", "124", "125", "126", "127", "128", "129"],
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
	{"ID" : "121", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "120"},
	{"ID" : "122", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "120"},
	{"ID" : "123", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "120"},
	{"ID" : "124", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "120"},
	{"ID" : "125", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "120"},
	{"ID" : "126", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "120"},
	{"ID" : "127", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "120"},
	{"ID" : "128", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "120"},
	{"ID" : "129", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "120"},
	{"ID" : "130", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400", "Parent" : "119", "Child" : ["131", "132", "133", "134", "135", "136", "137", "138", "139"],
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
	{"ID" : "131", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "130"},
	{"ID" : "132", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "130"},
	{"ID" : "133", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "130"},
	{"ID" : "134", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "130"},
	{"ID" : "135", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "130"},
	{"ID" : "136", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "130"},
	{"ID" : "137", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "130"},
	{"ID" : "138", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "130"},
	{"ID" : "139", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "130"},
	{"ID" : "140", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440", "Parent" : "119", "Child" : ["141", "142", "143", "144", "145", "146", "147", "148", "149"],
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
	{"ID" : "141", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "140"},
	{"ID" : "142", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "140"},
	{"ID" : "143", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "140"},
	{"ID" : "144", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "140"},
	{"ID" : "145", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "140"},
	{"ID" : "146", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "140"},
	{"ID" : "147", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "140"},
	{"ID" : "148", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "140"},
	{"ID" : "149", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "140"},
	{"ID" : "150", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480", "Parent" : "119", "Child" : ["151", "152", "153", "154", "155", "156", "157", "158", "159"],
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
	{"ID" : "151", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "150"},
	{"ID" : "152", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "150"},
	{"ID" : "153", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "150"},
	{"ID" : "154", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "150"},
	{"ID" : "155", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "150"},
	{"ID" : "156", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "150"},
	{"ID" : "157", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "150"},
	{"ID" : "158", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "150"},
	{"ID" : "159", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "150"},
	{"ID" : "160", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520", "Parent" : "119", "Child" : ["161", "162", "163", "164", "165", "166", "167", "168", "169"],
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
	{"ID" : "161", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "160"},
	{"ID" : "162", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "160"},
	{"ID" : "163", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "160"},
	{"ID" : "164", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "160"},
	{"ID" : "165", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "160"},
	{"ID" : "166", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "160"},
	{"ID" : "167", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "160"},
	{"ID" : "168", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "160"},
	{"ID" : "169", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "160"},
	{"ID" : "170", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560", "Parent" : "119", "Child" : ["171", "172", "173", "174", "175", "176", "177", "178", "179"],
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
	{"ID" : "171", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "170"},
	{"ID" : "172", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "170"},
	{"ID" : "173", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "170"},
	{"ID" : "174", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "170"},
	{"ID" : "175", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "170"},
	{"ID" : "176", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "170"},
	{"ID" : "177", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "170"},
	{"ID" : "178", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "170"},
	{"ID" : "179", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "170"},
	{"ID" : "180", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600", "Parent" : "119", "Child" : ["181", "182", "183", "184", "185", "186", "187", "188", "189"],
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
	{"ID" : "181", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "180"},
	{"ID" : "182", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "180"},
	{"ID" : "183", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "180"},
	{"ID" : "184", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "180"},
	{"ID" : "185", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "180"},
	{"ID" : "186", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "180"},
	{"ID" : "187", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "180"},
	{"ID" : "188", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "180"},
	{"ID" : "189", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "180"},
	{"ID" : "190", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640", "Parent" : "119", "Child" : ["191", "192", "193", "194", "195", "196", "197", "198", "199"],
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
	{"ID" : "191", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "190"},
	{"ID" : "192", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "190"},
	{"ID" : "193", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "190"},
	{"ID" : "194", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "190"},
	{"ID" : "195", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "190"},
	{"ID" : "196", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "190"},
	{"ID" : "197", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "190"},
	{"ID" : "198", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "190"},
	{"ID" : "199", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "190"},
	{"ID" : "200", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "119"},
	{"ID" : "201", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "119"},
	{"ID" : "202", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "119"},
	{"ID" : "203", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "119"},
	{"ID" : "204", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "119"},
	{"ID" : "205", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "119"},
	{"ID" : "206", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "119"},
	{"ID" : "207", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "119"},
	{"ID" : "208", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U195", "Parent" : "119"},
	{"ID" : "209", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U196", "Parent" : "119"},
	{"ID" : "210", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U197", "Parent" : "119"},
	{"ID" : "211", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U198", "Parent" : "119"},
	{"ID" : "212", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U199", "Parent" : "119"},
	{"ID" : "213", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U200", "Parent" : "119"},
	{"ID" : "214", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U201", "Parent" : "119"},
	{"ID" : "215", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U202", "Parent" : "119"},
	{"ID" : "216", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1359.sparsemux_17_3_32_1_1_U203", "Parent" : "119"},
	{"ID" : "217", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419", "Parent" : "2", "Child" : ["218", "228", "238", "248", "258", "268", "278", "288", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314"],
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
					{"ID" : "218", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "228", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "238", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "248", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "258", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "268", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "278", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "288", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "218", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "228", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "238", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "248", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "258", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "268", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "278", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "288", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
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
	{"ID" : "218", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360", "Parent" : "217", "Child" : ["219", "220", "221", "222", "223", "224", "225", "226", "227"],
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
	{"ID" : "219", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "218"},
	{"ID" : "220", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "218"},
	{"ID" : "221", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "218"},
	{"ID" : "222", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "218"},
	{"ID" : "223", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "218"},
	{"ID" : "224", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "218"},
	{"ID" : "225", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "218"},
	{"ID" : "226", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "218"},
	{"ID" : "227", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "218"},
	{"ID" : "228", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400", "Parent" : "217", "Child" : ["229", "230", "231", "232", "233", "234", "235", "236", "237"],
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
	{"ID" : "229", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "228"},
	{"ID" : "230", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "228"},
	{"ID" : "231", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "228"},
	{"ID" : "232", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "228"},
	{"ID" : "233", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "228"},
	{"ID" : "234", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "228"},
	{"ID" : "235", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "228"},
	{"ID" : "236", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "228"},
	{"ID" : "237", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "228"},
	{"ID" : "238", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440", "Parent" : "217", "Child" : ["239", "240", "241", "242", "243", "244", "245", "246", "247"],
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
	{"ID" : "239", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "238"},
	{"ID" : "240", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "238"},
	{"ID" : "241", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "238"},
	{"ID" : "242", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "238"},
	{"ID" : "243", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "238"},
	{"ID" : "244", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "238"},
	{"ID" : "245", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "238"},
	{"ID" : "246", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "238"},
	{"ID" : "247", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "238"},
	{"ID" : "248", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480", "Parent" : "217", "Child" : ["249", "250", "251", "252", "253", "254", "255", "256", "257"],
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
	{"ID" : "249", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "248"},
	{"ID" : "250", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "248"},
	{"ID" : "251", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "248"},
	{"ID" : "252", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "248"},
	{"ID" : "253", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "248"},
	{"ID" : "254", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "248"},
	{"ID" : "255", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "248"},
	{"ID" : "256", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "248"},
	{"ID" : "257", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "248"},
	{"ID" : "258", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520", "Parent" : "217", "Child" : ["259", "260", "261", "262", "263", "264", "265", "266", "267"],
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
	{"ID" : "259", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "258"},
	{"ID" : "260", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "258"},
	{"ID" : "261", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "258"},
	{"ID" : "262", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "258"},
	{"ID" : "263", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "258"},
	{"ID" : "264", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "258"},
	{"ID" : "265", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "258"},
	{"ID" : "266", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "258"},
	{"ID" : "267", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "258"},
	{"ID" : "268", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560", "Parent" : "217", "Child" : ["269", "270", "271", "272", "273", "274", "275", "276", "277"],
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
	{"ID" : "269", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "268"},
	{"ID" : "270", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "268"},
	{"ID" : "271", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "268"},
	{"ID" : "272", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "268"},
	{"ID" : "273", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "268"},
	{"ID" : "274", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "268"},
	{"ID" : "275", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "268"},
	{"ID" : "276", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "268"},
	{"ID" : "277", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "268"},
	{"ID" : "278", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600", "Parent" : "217", "Child" : ["279", "280", "281", "282", "283", "284", "285", "286", "287"],
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
	{"ID" : "279", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "278"},
	{"ID" : "280", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "278"},
	{"ID" : "281", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "278"},
	{"ID" : "282", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "278"},
	{"ID" : "283", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "278"},
	{"ID" : "284", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "278"},
	{"ID" : "285", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "278"},
	{"ID" : "286", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "278"},
	{"ID" : "287", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "278"},
	{"ID" : "288", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640", "Parent" : "217", "Child" : ["289", "290", "291", "292", "293", "294", "295", "296", "297"],
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
	{"ID" : "289", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "288"},
	{"ID" : "290", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "288"},
	{"ID" : "291", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "288"},
	{"ID" : "292", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "288"},
	{"ID" : "293", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "288"},
	{"ID" : "294", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "288"},
	{"ID" : "295", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "288"},
	{"ID" : "296", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "288"},
	{"ID" : "297", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "288"},
	{"ID" : "298", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "217"},
	{"ID" : "299", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "217"},
	{"ID" : "300", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "217"},
	{"ID" : "301", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "217"},
	{"ID" : "302", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "217"},
	{"ID" : "303", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "217"},
	{"ID" : "304", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "217"},
	{"ID" : "305", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "217"},
	{"ID" : "306", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U195", "Parent" : "217"},
	{"ID" : "307", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U196", "Parent" : "217"},
	{"ID" : "308", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U197", "Parent" : "217"},
	{"ID" : "309", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U198", "Parent" : "217"},
	{"ID" : "310", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U199", "Parent" : "217"},
	{"ID" : "311", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U200", "Parent" : "217"},
	{"ID" : "312", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U201", "Parent" : "217"},
	{"ID" : "313", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U202", "Parent" : "217"},
	{"ID" : "314", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1419.sparsemux_17_3_32_1_1_U203", "Parent" : "217"},
	{"ID" : "315", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479", "Parent" : "2", "Child" : ["316", "326", "336", "346", "356", "366", "376", "386", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412"],
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
					{"ID" : "316", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "326", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "336", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "346", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "356", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "366", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "376", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "386", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "316", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "326", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "336", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "346", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "356", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "366", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "376", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "386", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
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
	{"ID" : "316", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360", "Parent" : "315", "Child" : ["317", "318", "319", "320", "321", "322", "323", "324", "325"],
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
	{"ID" : "317", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "316"},
	{"ID" : "318", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "316"},
	{"ID" : "319", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "316"},
	{"ID" : "320", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "316"},
	{"ID" : "321", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "316"},
	{"ID" : "322", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "316"},
	{"ID" : "323", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "316"},
	{"ID" : "324", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "316"},
	{"ID" : "325", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "316"},
	{"ID" : "326", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400", "Parent" : "315", "Child" : ["327", "328", "329", "330", "331", "332", "333", "334", "335"],
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
	{"ID" : "327", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "326"},
	{"ID" : "328", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "326"},
	{"ID" : "329", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "326"},
	{"ID" : "330", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "326"},
	{"ID" : "331", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "326"},
	{"ID" : "332", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "326"},
	{"ID" : "333", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "326"},
	{"ID" : "334", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "326"},
	{"ID" : "335", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "326"},
	{"ID" : "336", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440", "Parent" : "315", "Child" : ["337", "338", "339", "340", "341", "342", "343", "344", "345"],
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
	{"ID" : "337", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "336"},
	{"ID" : "338", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "336"},
	{"ID" : "339", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "336"},
	{"ID" : "340", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "336"},
	{"ID" : "341", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "336"},
	{"ID" : "342", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "336"},
	{"ID" : "343", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "336"},
	{"ID" : "344", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "336"},
	{"ID" : "345", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "336"},
	{"ID" : "346", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480", "Parent" : "315", "Child" : ["347", "348", "349", "350", "351", "352", "353", "354", "355"],
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
	{"ID" : "347", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "346"},
	{"ID" : "348", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "346"},
	{"ID" : "349", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "346"},
	{"ID" : "350", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "346"},
	{"ID" : "351", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "346"},
	{"ID" : "352", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "346"},
	{"ID" : "353", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "346"},
	{"ID" : "354", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "346"},
	{"ID" : "355", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "346"},
	{"ID" : "356", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520", "Parent" : "315", "Child" : ["357", "358", "359", "360", "361", "362", "363", "364", "365"],
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
	{"ID" : "357", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "356"},
	{"ID" : "358", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "356"},
	{"ID" : "359", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "356"},
	{"ID" : "360", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "356"},
	{"ID" : "361", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "356"},
	{"ID" : "362", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "356"},
	{"ID" : "363", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "356"},
	{"ID" : "364", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "356"},
	{"ID" : "365", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "356"},
	{"ID" : "366", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560", "Parent" : "315", "Child" : ["367", "368", "369", "370", "371", "372", "373", "374", "375"],
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
	{"ID" : "367", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "366"},
	{"ID" : "368", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "366"},
	{"ID" : "369", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "366"},
	{"ID" : "370", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "366"},
	{"ID" : "371", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "366"},
	{"ID" : "372", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "366"},
	{"ID" : "373", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "366"},
	{"ID" : "374", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "366"},
	{"ID" : "375", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "366"},
	{"ID" : "376", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600", "Parent" : "315", "Child" : ["377", "378", "379", "380", "381", "382", "383", "384", "385"],
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
	{"ID" : "377", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "376"},
	{"ID" : "378", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "376"},
	{"ID" : "379", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "376"},
	{"ID" : "380", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "376"},
	{"ID" : "381", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "376"},
	{"ID" : "382", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "376"},
	{"ID" : "383", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "376"},
	{"ID" : "384", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "376"},
	{"ID" : "385", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "376"},
	{"ID" : "386", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640", "Parent" : "315", "Child" : ["387", "388", "389", "390", "391", "392", "393", "394", "395"],
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
	{"ID" : "387", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "386"},
	{"ID" : "388", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "386"},
	{"ID" : "389", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "386"},
	{"ID" : "390", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "386"},
	{"ID" : "391", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "386"},
	{"ID" : "392", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "386"},
	{"ID" : "393", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "386"},
	{"ID" : "394", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "386"},
	{"ID" : "395", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "386"},
	{"ID" : "396", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "315"},
	{"ID" : "397", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "315"},
	{"ID" : "398", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "315"},
	{"ID" : "399", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "315"},
	{"ID" : "400", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "315"},
	{"ID" : "401", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "315"},
	{"ID" : "402", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "315"},
	{"ID" : "403", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "315"},
	{"ID" : "404", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U195", "Parent" : "315"},
	{"ID" : "405", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U196", "Parent" : "315"},
	{"ID" : "406", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U197", "Parent" : "315"},
	{"ID" : "407", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U198", "Parent" : "315"},
	{"ID" : "408", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U199", "Parent" : "315"},
	{"ID" : "409", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U200", "Parent" : "315"},
	{"ID" : "410", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U201", "Parent" : "315"},
	{"ID" : "411", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U202", "Parent" : "315"},
	{"ID" : "412", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.grp_compute_mac_fu_1479.sparsemux_17_3_32_1_1_U203", "Parent" : "315"},
	{"ID" : "413", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "414", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "415", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "416", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "417", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "418", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "419", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "420", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi0_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "421", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "422", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "423", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "424", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "425", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "426", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "427", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "428", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi1_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "429", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "430", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "431", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "432", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "433", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "434", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "435", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "436", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi2_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "437", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "438", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "439", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "440", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "441", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "442", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "443", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "444", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.xi3_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "445", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "446", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "447", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "448", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "449", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "450", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "451", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "452", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro0_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "453", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "454", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "455", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "456", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "457", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "458", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "459", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "460", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro1_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "461", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "462", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "463", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "464", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "465", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "466", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "467", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "468", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro2_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "469", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_0_fifo_U", "Parent" : "2"},
	{"ID" : "470", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_1_fifo_U", "Parent" : "2"},
	{"ID" : "471", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_2_fifo_U", "Parent" : "2"},
	{"ID" : "472", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_3_fifo_U", "Parent" : "2"},
	{"ID" : "473", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_4_fifo_U", "Parent" : "2"},
	{"ID" : "474", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_5_fifo_U", "Parent" : "2"},
	{"ID" : "475", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_6_fifo_U", "Parent" : "2"},
	{"ID" : "476", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_324_2_proc_U0.mro3_s_M_elems_V_7_fifo_U", "Parent" : "2"},
	{"ID" : "477", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_337_3_proc_U0", "Parent" : "0", "Child" : ["478"],
		"CDFG" : "Loop_VITIS_LOOP_337_3_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "9", "EstimateLatencyMax" : "9",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "509", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "513", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "510", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "514", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "511", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "515", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "512", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "516", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read8", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "501", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read9", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "505", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read10", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "502", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read11", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "506", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read12", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "503", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read13", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "507", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read14", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "504", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read15", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "508", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read16", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "493", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read17", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "497", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read18", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "494", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read19", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "498", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read20", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "495", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read21", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "499", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read22", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "496", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read23", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "500", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read24", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "485", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read25", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "489", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read26", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "486", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read27", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "490", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read28", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "487", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read29", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "491", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read30", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "488", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read31", "Type" : "None", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "492", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "out_r", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_337_3_VITIS_LOOP_338_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state1", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state1_blk", "QuitState" : "ap_ST_fsm_state1", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state1_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "478", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_337_3_proc_U0.flow_control_loop_pipe_U", "Parent" : "477"},
	{"ID" : "479", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xi_c_U", "Parent" : "0"},
	{"ID" : "480", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro0_c_U", "Parent" : "0"},
	{"ID" : "481", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro1_c_U", "Parent" : "0"},
	{"ID" : "482", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro2_c_U", "Parent" : "0"},
	{"ID" : "483", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mro3_c_U", "Parent" : "0"},
	{"ID" : "484", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.row_c_U", "Parent" : "0"},
	{"ID" : "485", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_U", "Parent" : "0"},
	{"ID" : "486", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_1_U", "Parent" : "0"},
	{"ID" : "487", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_2_U", "Parent" : "0"},
	{"ID" : "488", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_3_U", "Parent" : "0"},
	{"ID" : "489", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_4_U", "Parent" : "0"},
	{"ID" : "490", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_5_U", "Parent" : "0"},
	{"ID" : "491", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_6_U", "Parent" : "0"},
	{"ID" : "492", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local0_7_U", "Parent" : "0"},
	{"ID" : "493", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_U", "Parent" : "0"},
	{"ID" : "494", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_1_U", "Parent" : "0"},
	{"ID" : "495", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_2_U", "Parent" : "0"},
	{"ID" : "496", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_3_U", "Parent" : "0"},
	{"ID" : "497", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_4_U", "Parent" : "0"},
	{"ID" : "498", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_5_U", "Parent" : "0"},
	{"ID" : "499", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_6_U", "Parent" : "0"},
	{"ID" : "500", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local1_7_U", "Parent" : "0"},
	{"ID" : "501", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_U", "Parent" : "0"},
	{"ID" : "502", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_1_U", "Parent" : "0"},
	{"ID" : "503", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_2_U", "Parent" : "0"},
	{"ID" : "504", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_3_U", "Parent" : "0"},
	{"ID" : "505", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_4_U", "Parent" : "0"},
	{"ID" : "506", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_5_U", "Parent" : "0"},
	{"ID" : "507", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_6_U", "Parent" : "0"},
	{"ID" : "508", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local2_7_U", "Parent" : "0"},
	{"ID" : "509", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_U", "Parent" : "0"},
	{"ID" : "510", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_1_U", "Parent" : "0"},
	{"ID" : "511", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_2_U", "Parent" : "0"},
	{"ID" : "512", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_3_U", "Parent" : "0"},
	{"ID" : "513", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_4_U", "Parent" : "0"},
	{"ID" : "514", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_5_U", "Parent" : "0"},
	{"ID" : "515", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_6_U", "Parent" : "0"},
	{"ID" : "516", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pout_local3_7_U", "Parent" : "0"},
	{"ID" : "517", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_Loop_VITIS_LOOP_324_2_proc_U0_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	Macro_MAC_Acc4_top {
		out_r {Type O LastRead -1 FirstWrite 0}
		xi {Type I LastRead 0 FirstWrite -1}
		mro0 {Type I LastRead 0 FirstWrite -1}
		mro1 {Type I LastRead 0 FirstWrite -1}
		mro2 {Type I LastRead 0 FirstWrite -1}
		mro3 {Type I LastRead 0 FirstWrite -1}
		row {Type I LastRead 0 FirstWrite -1}
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
		row_c {Type O LastRead -1 FirstWrite 0}}
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
		qscale_7_val {Type I LastRead 0 FirstWrite -1}}
	Loop_VITIS_LOOP_337_3_proc {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		p_read8 {Type I LastRead 0 FirstWrite -1}
		p_read9 {Type I LastRead 0 FirstWrite -1}
		p_read10 {Type I LastRead 0 FirstWrite -1}
		p_read11 {Type I LastRead 0 FirstWrite -1}
		p_read12 {Type I LastRead 0 FirstWrite -1}
		p_read13 {Type I LastRead 0 FirstWrite -1}
		p_read14 {Type I LastRead 0 FirstWrite -1}
		p_read15 {Type I LastRead 0 FirstWrite -1}
		p_read16 {Type I LastRead 0 FirstWrite -1}
		p_read17 {Type I LastRead 0 FirstWrite -1}
		p_read18 {Type I LastRead 0 FirstWrite -1}
		p_read19 {Type I LastRead 0 FirstWrite -1}
		p_read20 {Type I LastRead 0 FirstWrite -1}
		p_read21 {Type I LastRead 0 FirstWrite -1}
		p_read22 {Type I LastRead 0 FirstWrite -1}
		p_read23 {Type I LastRead 0 FirstWrite -1}
		p_read24 {Type I LastRead 0 FirstWrite -1}
		p_read25 {Type I LastRead 0 FirstWrite -1}
		p_read26 {Type I LastRead 0 FirstWrite -1}
		p_read27 {Type I LastRead 0 FirstWrite -1}
		p_read28 {Type I LastRead 0 FirstWrite -1}
		p_read29 {Type I LastRead 0 FirstWrite -1}
		p_read30 {Type I LastRead 0 FirstWrite -1}
		p_read31 {Type I LastRead 0 FirstWrite -1}
		out_r {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2742", "Max" : "2742"}
	, {"Name" : "Interval", "Min" : "2732", "Max" : "2732"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	out_r { ap_vld {  { out_r out_data 1 128 }  { out_r_ap_vld out_vld 1 1 } } }
	xi { ap_none {  { xi in_data 0 128 } } }
	mro0 { ap_none {  { mro0 in_data 0 128 } } }
	mro1 { ap_none {  { mro1 in_data 0 128 } } }
	mro2 { ap_none {  { mro2 in_data 0 128 } } }
	mro3 { ap_none {  { mro3 in_data 0 128 } } }
	row { ap_none {  { row in_data 0 16 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
