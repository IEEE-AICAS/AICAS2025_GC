set moduleName w4a8_gemm_Pipeline_7
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {w4a8_gemm_Pipeline_7}
set C_modelType { void 0 }
set C_modelArgList {
	{ m02_axi int 512 regular {axi_master 0}  }
	{ sext_ln103 int 58 regular  }
	{ m02_axi_input_buffer int 32 regular {array 8192 { 0 3 } 0 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "m02_axi", "interface" : "axi_master", "bitwidth" : 512, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "axi02_ptr0","offset": { "type": "dynamic","port_name": "axi02_ptr0","bundle": "control"},"direction": "READWRITE"}]}]} , 
 	{ "Name" : "sext_ln103", "interface" : "wire", "bitwidth" : 58, "direction" : "READONLY"} , 
 	{ "Name" : "m02_axi_input_buffer", "interface" : "memory", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 57
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ m_axi_m02_axi_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_m02_axi_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_AWLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_m02_axi_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_m02_axi_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_m02_axi_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_WDATA sc_out sc_lv 512 signal 0 } 
	{ m_axi_m02_axi_WSTRB sc_out sc_lv 64 signal 0 } 
	{ m_axi_m02_axi_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_m02_axi_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_ARLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_m02_axi_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_m02_axi_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_m02_axi_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_m02_axi_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_RDATA sc_in sc_lv 512 signal 0 } 
	{ m_axi_m02_axi_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_RFIFONUM sc_in sc_lv 9 signal 0 } 
	{ m_axi_m02_axi_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_m02_axi_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_m02_axi_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_m02_axi_BUSER sc_in sc_lv 1 signal 0 } 
	{ sext_ln103 sc_in sc_lv 58 signal 1 } 
	{ m02_axi_input_buffer_address0 sc_out sc_lv 13 signal 2 } 
	{ m02_axi_input_buffer_ce0 sc_out sc_logic 1 signal 2 } 
	{ m02_axi_input_buffer_we0 sc_out sc_logic 1 signal 2 } 
	{ m02_axi_input_buffer_d0 sc_out sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "m_axi_m02_axi_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWVALID" }} , 
 	{ "name": "m_axi_m02_axi_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWREADY" }} , 
 	{ "name": "m_axi_m02_axi_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWADDR" }} , 
 	{ "name": "m_axi_m02_axi_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWID" }} , 
 	{ "name": "m_axi_m02_axi_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWLEN" }} , 
 	{ "name": "m_axi_m02_axi_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_m02_axi_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWBURST" }} , 
 	{ "name": "m_axi_m02_axi_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_m02_axi_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_m02_axi_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWPROT" }} , 
 	{ "name": "m_axi_m02_axi_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWQOS" }} , 
 	{ "name": "m_axi_m02_axi_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWREGION" }} , 
 	{ "name": "m_axi_m02_axi_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "AWUSER" }} , 
 	{ "name": "m_axi_m02_axi_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "WVALID" }} , 
 	{ "name": "m_axi_m02_axi_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "WREADY" }} , 
 	{ "name": "m_axi_m02_axi_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":512, "type": "signal", "bundle":{"name": "m02_axi", "role": "WDATA" }} , 
 	{ "name": "m_axi_m02_axi_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "m02_axi", "role": "WSTRB" }} , 
 	{ "name": "m_axi_m02_axi_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "WLAST" }} , 
 	{ "name": "m_axi_m02_axi_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "WID" }} , 
 	{ "name": "m_axi_m02_axi_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "WUSER" }} , 
 	{ "name": "m_axi_m02_axi_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARVALID" }} , 
 	{ "name": "m_axi_m02_axi_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARREADY" }} , 
 	{ "name": "m_axi_m02_axi_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARADDR" }} , 
 	{ "name": "m_axi_m02_axi_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARID" }} , 
 	{ "name": "m_axi_m02_axi_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARLEN" }} , 
 	{ "name": "m_axi_m02_axi_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_m02_axi_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARBURST" }} , 
 	{ "name": "m_axi_m02_axi_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_m02_axi_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_m02_axi_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARPROT" }} , 
 	{ "name": "m_axi_m02_axi_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARQOS" }} , 
 	{ "name": "m_axi_m02_axi_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARREGION" }} , 
 	{ "name": "m_axi_m02_axi_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "ARUSER" }} , 
 	{ "name": "m_axi_m02_axi_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "RVALID" }} , 
 	{ "name": "m_axi_m02_axi_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "RREADY" }} , 
 	{ "name": "m_axi_m02_axi_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":512, "type": "signal", "bundle":{"name": "m02_axi", "role": "RDATA" }} , 
 	{ "name": "m_axi_m02_axi_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "RLAST" }} , 
 	{ "name": "m_axi_m02_axi_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "RID" }} , 
 	{ "name": "m_axi_m02_axi_RFIFONUM", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "m02_axi", "role": "RFIFONUM" }} , 
 	{ "name": "m_axi_m02_axi_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "RUSER" }} , 
 	{ "name": "m_axi_m02_axi_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "RRESP" }} , 
 	{ "name": "m_axi_m02_axi_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "BVALID" }} , 
 	{ "name": "m_axi_m02_axi_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "BREADY" }} , 
 	{ "name": "m_axi_m02_axi_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "m02_axi", "role": "BRESP" }} , 
 	{ "name": "m_axi_m02_axi_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "BID" }} , 
 	{ "name": "m_axi_m02_axi_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi", "role": "BUSER" }} , 
 	{ "name": "sext_ln103", "direction": "in", "datatype": "sc_lv", "bitwidth":58, "type": "signal", "bundle":{"name": "sext_ln103", "role": "default" }} , 
 	{ "name": "m02_axi_input_buffer_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "m02_axi_input_buffer", "role": "address0" }} , 
 	{ "name": "m02_axi_input_buffer_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi_input_buffer", "role": "ce0" }} , 
 	{ "name": "m02_axi_input_buffer_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "m02_axi_input_buffer", "role": "we0" }} , 
 	{ "name": "m02_axi_input_buffer_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m02_axi_input_buffer", "role": "d0" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "w4a8_gemm_Pipeline_7",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4099", "EstimateLatencyMax" : "4099",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "m02_axi", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "m02_axi_blk_n_R", "Type" : "RtlSignal"}]},
			{"Name" : "sext_ln103", "Type" : "None", "Direction" : "I"},
			{"Name" : "m02_axi_input_buffer", "Type" : "Memory", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "Loop 1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	w4a8_gemm_Pipeline_7 {
		m02_axi {Type I LastRead 1 FirstWrite -1}
		sext_ln103 {Type I LastRead 0 FirstWrite -1}
		m02_axi_input_buffer {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "4099", "Max" : "4099"}
	, {"Name" : "Interval", "Min" : "4099", "Max" : "4099"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	 { m_axi {  { m_axi_m02_axi_AWVALID VALID 1 1 }  { m_axi_m02_axi_AWREADY READY 0 1 }  { m_axi_m02_axi_AWADDR ADDR 1 64 }  { m_axi_m02_axi_AWID ID 1 1 }  { m_axi_m02_axi_AWLEN SIZE 1 32 }  { m_axi_m02_axi_AWSIZE BURST 1 3 }  { m_axi_m02_axi_AWBURST LOCK 1 2 }  { m_axi_m02_axi_AWLOCK CACHE 1 2 }  { m_axi_m02_axi_AWCACHE PROT 1 4 }  { m_axi_m02_axi_AWPROT QOS 1 3 }  { m_axi_m02_axi_AWQOS REGION 1 4 }  { m_axi_m02_axi_AWREGION USER 1 4 }  { m_axi_m02_axi_AWUSER DATA 1 1 }  { m_axi_m02_axi_WVALID VALID 1 1 }  { m_axi_m02_axi_WREADY READY 0 1 }  { m_axi_m02_axi_WDATA FIFONUM 1 512 }  { m_axi_m02_axi_WSTRB STRB 1 64 }  { m_axi_m02_axi_WLAST LAST 1 1 }  { m_axi_m02_axi_WID ID 1 1 }  { m_axi_m02_axi_WUSER DATA 1 1 }  { m_axi_m02_axi_ARVALID VALID 1 1 }  { m_axi_m02_axi_ARREADY READY 0 1 }  { m_axi_m02_axi_ARADDR ADDR 1 64 }  { m_axi_m02_axi_ARID ID 1 1 }  { m_axi_m02_axi_ARLEN SIZE 1 32 }  { m_axi_m02_axi_ARSIZE BURST 1 3 }  { m_axi_m02_axi_ARBURST LOCK 1 2 }  { m_axi_m02_axi_ARLOCK CACHE 1 2 }  { m_axi_m02_axi_ARCACHE PROT 1 4 }  { m_axi_m02_axi_ARPROT QOS 1 3 }  { m_axi_m02_axi_ARQOS REGION 1 4 }  { m_axi_m02_axi_ARREGION USER 1 4 }  { m_axi_m02_axi_ARUSER DATA 1 1 }  { m_axi_m02_axi_RVALID VALID 0 1 }  { m_axi_m02_axi_RREADY READY 1 1 }  { m_axi_m02_axi_RDATA FIFONUM 0 512 }  { m_axi_m02_axi_RLAST LAST 0 1 }  { m_axi_m02_axi_RID ID 0 1 }  { m_axi_m02_axi_RFIFONUM LEN 0 9 }  { m_axi_m02_axi_RUSER DATA 0 1 }  { m_axi_m02_axi_RRESP RESP 0 2 }  { m_axi_m02_axi_BVALID VALID 0 1 }  { m_axi_m02_axi_BREADY READY 1 1 }  { m_axi_m02_axi_BRESP RESP 0 2 }  { m_axi_m02_axi_BID ID 0 1 }  { m_axi_m02_axi_BUSER DATA 0 1 } } }
	sext_ln103 { ap_none {  { sext_ln103 in_data 0 58 } } }
	m02_axi_input_buffer { ap_memory {  { m02_axi_input_buffer_address0 mem_address 1 13 }  { m02_axi_input_buffer_ce0 mem_ce 1 1 }  { m02_axi_input_buffer_we0 mem_we 1 1 }  { m02_axi_input_buffer_d0 mem_din 1 32 } } }
}
