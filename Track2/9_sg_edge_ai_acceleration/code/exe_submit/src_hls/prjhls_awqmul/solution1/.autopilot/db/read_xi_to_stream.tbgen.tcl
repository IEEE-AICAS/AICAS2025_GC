set moduleName read_xi_to_stream
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
set C_modelName {read_xi_to_stream}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ p_read int 128 regular  }
	{ xi3_s_M_elems_V_2 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_6 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_1 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_5 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_0 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_4 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_2 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_6 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_1 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_5 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_0 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_4 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_2 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_6 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_1 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_5 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_0 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_4 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_3 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_3 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_3 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_3 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_7 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi1_s_M_elems_V_7 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi2_s_M_elems_V_7 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi3_s_M_elems_V_7 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_2 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_6 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_1 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_5 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_0 float 32 regular {fifo 1 volatile } {global 1}  }
	{ xi0_s_M_elems_V_4 float 32 regular {fifo 1 volatile } {global 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "xi3_s_M_elems_V_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_6", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_5", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_4", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_6", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_5", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_4", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_6", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_5", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_4", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_3", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_3", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_3", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_3", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_7", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi1_s_M_elems_V_7", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi2_s_M_elems_V_7", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi3_s_M_elems_V_7", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_2", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_6", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_1", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_5", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "xi0_s_M_elems_V_4", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY", "extern" : 0} ]}
# RTL Port declarations: 
set portNum 103
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ xi0_s_M_elems_V_0_din sc_out sc_lv 32 signal 31 } 
	{ xi0_s_M_elems_V_0_full_n sc_in sc_logic 1 signal 31 } 
	{ xi0_s_M_elems_V_0_write sc_out sc_logic 1 signal 31 } 
	{ xi0_s_M_elems_V_4_din sc_out sc_lv 32 signal 32 } 
	{ xi0_s_M_elems_V_4_full_n sc_in sc_logic 1 signal 32 } 
	{ xi0_s_M_elems_V_4_write sc_out sc_logic 1 signal 32 } 
	{ xi1_s_M_elems_V_0_din sc_out sc_lv 32 signal 17 } 
	{ xi1_s_M_elems_V_0_full_n sc_in sc_logic 1 signal 17 } 
	{ xi1_s_M_elems_V_0_write sc_out sc_logic 1 signal 17 } 
	{ xi1_s_M_elems_V_4_din sc_out sc_lv 32 signal 18 } 
	{ xi1_s_M_elems_V_4_full_n sc_in sc_logic 1 signal 18 } 
	{ xi1_s_M_elems_V_4_write sc_out sc_logic 1 signal 18 } 
	{ xi2_s_M_elems_V_0_din sc_out sc_lv 32 signal 11 } 
	{ xi2_s_M_elems_V_0_full_n sc_in sc_logic 1 signal 11 } 
	{ xi2_s_M_elems_V_0_write sc_out sc_logic 1 signal 11 } 
	{ xi2_s_M_elems_V_4_din sc_out sc_lv 32 signal 12 } 
	{ xi2_s_M_elems_V_4_full_n sc_in sc_logic 1 signal 12 } 
	{ xi2_s_M_elems_V_4_write sc_out sc_logic 1 signal 12 } 
	{ xi3_s_M_elems_V_0_din sc_out sc_lv 32 signal 5 } 
	{ xi3_s_M_elems_V_0_full_n sc_in sc_logic 1 signal 5 } 
	{ xi3_s_M_elems_V_0_write sc_out sc_logic 1 signal 5 } 
	{ xi3_s_M_elems_V_4_din sc_out sc_lv 32 signal 6 } 
	{ xi3_s_M_elems_V_4_full_n sc_in sc_logic 1 signal 6 } 
	{ xi3_s_M_elems_V_4_write sc_out sc_logic 1 signal 6 } 
	{ xi0_s_M_elems_V_1_din sc_out sc_lv 32 signal 29 } 
	{ xi0_s_M_elems_V_1_full_n sc_in sc_logic 1 signal 29 } 
	{ xi0_s_M_elems_V_1_write sc_out sc_logic 1 signal 29 } 
	{ xi0_s_M_elems_V_5_din sc_out sc_lv 32 signal 30 } 
	{ xi0_s_M_elems_V_5_full_n sc_in sc_logic 1 signal 30 } 
	{ xi0_s_M_elems_V_5_write sc_out sc_logic 1 signal 30 } 
	{ xi1_s_M_elems_V_1_din sc_out sc_lv 32 signal 15 } 
	{ xi1_s_M_elems_V_1_full_n sc_in sc_logic 1 signal 15 } 
	{ xi1_s_M_elems_V_1_write sc_out sc_logic 1 signal 15 } 
	{ xi1_s_M_elems_V_5_din sc_out sc_lv 32 signal 16 } 
	{ xi1_s_M_elems_V_5_full_n sc_in sc_logic 1 signal 16 } 
	{ xi1_s_M_elems_V_5_write sc_out sc_logic 1 signal 16 } 
	{ xi2_s_M_elems_V_1_din sc_out sc_lv 32 signal 9 } 
	{ xi2_s_M_elems_V_1_full_n sc_in sc_logic 1 signal 9 } 
	{ xi2_s_M_elems_V_1_write sc_out sc_logic 1 signal 9 } 
	{ xi2_s_M_elems_V_5_din sc_out sc_lv 32 signal 10 } 
	{ xi2_s_M_elems_V_5_full_n sc_in sc_logic 1 signal 10 } 
	{ xi2_s_M_elems_V_5_write sc_out sc_logic 1 signal 10 } 
	{ xi3_s_M_elems_V_1_din sc_out sc_lv 32 signal 3 } 
	{ xi3_s_M_elems_V_1_full_n sc_in sc_logic 1 signal 3 } 
	{ xi3_s_M_elems_V_1_write sc_out sc_logic 1 signal 3 } 
	{ xi3_s_M_elems_V_5_din sc_out sc_lv 32 signal 4 } 
	{ xi3_s_M_elems_V_5_full_n sc_in sc_logic 1 signal 4 } 
	{ xi3_s_M_elems_V_5_write sc_out sc_logic 1 signal 4 } 
	{ xi0_s_M_elems_V_2_din sc_out sc_lv 32 signal 27 } 
	{ xi0_s_M_elems_V_2_full_n sc_in sc_logic 1 signal 27 } 
	{ xi0_s_M_elems_V_2_write sc_out sc_logic 1 signal 27 } 
	{ xi0_s_M_elems_V_6_din sc_out sc_lv 32 signal 28 } 
	{ xi0_s_M_elems_V_6_full_n sc_in sc_logic 1 signal 28 } 
	{ xi0_s_M_elems_V_6_write sc_out sc_logic 1 signal 28 } 
	{ xi1_s_M_elems_V_2_din sc_out sc_lv 32 signal 13 } 
	{ xi1_s_M_elems_V_2_full_n sc_in sc_logic 1 signal 13 } 
	{ xi1_s_M_elems_V_2_write sc_out sc_logic 1 signal 13 } 
	{ xi1_s_M_elems_V_6_din sc_out sc_lv 32 signal 14 } 
	{ xi1_s_M_elems_V_6_full_n sc_in sc_logic 1 signal 14 } 
	{ xi1_s_M_elems_V_6_write sc_out sc_logic 1 signal 14 } 
	{ xi2_s_M_elems_V_2_din sc_out sc_lv 32 signal 7 } 
	{ xi2_s_M_elems_V_2_full_n sc_in sc_logic 1 signal 7 } 
	{ xi2_s_M_elems_V_2_write sc_out sc_logic 1 signal 7 } 
	{ xi2_s_M_elems_V_6_din sc_out sc_lv 32 signal 8 } 
	{ xi2_s_M_elems_V_6_full_n sc_in sc_logic 1 signal 8 } 
	{ xi2_s_M_elems_V_6_write sc_out sc_logic 1 signal 8 } 
	{ xi3_s_M_elems_V_2_din sc_out sc_lv 32 signal 1 } 
	{ xi3_s_M_elems_V_2_full_n sc_in sc_logic 1 signal 1 } 
	{ xi3_s_M_elems_V_2_write sc_out sc_logic 1 signal 1 } 
	{ xi3_s_M_elems_V_6_din sc_out sc_lv 32 signal 2 } 
	{ xi3_s_M_elems_V_6_full_n sc_in sc_logic 1 signal 2 } 
	{ xi3_s_M_elems_V_6_write sc_out sc_logic 1 signal 2 } 
	{ xi0_s_M_elems_V_7_din sc_out sc_lv 32 signal 23 } 
	{ xi0_s_M_elems_V_7_full_n sc_in sc_logic 1 signal 23 } 
	{ xi0_s_M_elems_V_7_write sc_out sc_logic 1 signal 23 } 
	{ xi1_s_M_elems_V_7_din sc_out sc_lv 32 signal 24 } 
	{ xi1_s_M_elems_V_7_full_n sc_in sc_logic 1 signal 24 } 
	{ xi1_s_M_elems_V_7_write sc_out sc_logic 1 signal 24 } 
	{ xi2_s_M_elems_V_7_din sc_out sc_lv 32 signal 25 } 
	{ xi2_s_M_elems_V_7_full_n sc_in sc_logic 1 signal 25 } 
	{ xi2_s_M_elems_V_7_write sc_out sc_logic 1 signal 25 } 
	{ xi3_s_M_elems_V_7_din sc_out sc_lv 32 signal 26 } 
	{ xi3_s_M_elems_V_7_full_n sc_in sc_logic 1 signal 26 } 
	{ xi3_s_M_elems_V_7_write sc_out sc_logic 1 signal 26 } 
	{ xi0_s_M_elems_V_3_din sc_out sc_lv 32 signal 19 } 
	{ xi0_s_M_elems_V_3_full_n sc_in sc_logic 1 signal 19 } 
	{ xi0_s_M_elems_V_3_write sc_out sc_logic 1 signal 19 } 
	{ xi1_s_M_elems_V_3_din sc_out sc_lv 32 signal 20 } 
	{ xi1_s_M_elems_V_3_full_n sc_in sc_logic 1 signal 20 } 
	{ xi1_s_M_elems_V_3_write sc_out sc_logic 1 signal 20 } 
	{ xi2_s_M_elems_V_3_din sc_out sc_lv 32 signal 21 } 
	{ xi2_s_M_elems_V_3_full_n sc_in sc_logic 1 signal 21 } 
	{ xi2_s_M_elems_V_3_write sc_out sc_logic 1 signal 21 } 
	{ xi3_s_M_elems_V_3_din sc_out sc_lv 32 signal 22 } 
	{ xi3_s_M_elems_V_3_full_n sc_in sc_logic 1 signal 22 } 
	{ xi3_s_M_elems_V_3_write sc_out sc_logic 1 signal 22 } 
	{ p_read sc_in sc_lv 128 signal 0 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "xi0_s_M_elems_V_0_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_0", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_0_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_0", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_0_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_0", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_4", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_4", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_4", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_0_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_0", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_0_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_0", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_0_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_0", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_4", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_4", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_4", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_0_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_0", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_0_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_0", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_0_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_0", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_4", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_4", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_4", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_0_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_0", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_0_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_0", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_0_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_0", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_4", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_4", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_4", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_1", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_1", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_1", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_5", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_5", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_5", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_1", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_1", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_1", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_5", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_5", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_5", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_1", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_1", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_1", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_5", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_5", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_5", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_1_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_1", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_1_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_1", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_1_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_1", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_5", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_5", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_5", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_2_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_2", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_2_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_2", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_2_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_2", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_6", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_6", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_6", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_2_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_2", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_2_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_2", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_2_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_2", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_6", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_6", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_6", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_2_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_2", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_2_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_2", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_2_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_2", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_6", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_6", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_6", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_2_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_2", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_2_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_2", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_2_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_2", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_6", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_6", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_6", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_7_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_7", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_7_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_7", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_7_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_7", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_7_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_7", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_7_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_7", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_7_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_7", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_7_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_7", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_7_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_7", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_7_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_7", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_7_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_7", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_7_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_7", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_7_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_7", "role": "write" }} , 
 	{ "name": "xi0_s_M_elems_V_3_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_3", "role": "din" }} , 
 	{ "name": "xi0_s_M_elems_V_3_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_3", "role": "full_n" }} , 
 	{ "name": "xi0_s_M_elems_V_3_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi0_s_M_elems_V_3", "role": "write" }} , 
 	{ "name": "xi1_s_M_elems_V_3_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_3", "role": "din" }} , 
 	{ "name": "xi1_s_M_elems_V_3_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_3", "role": "full_n" }} , 
 	{ "name": "xi1_s_M_elems_V_3_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi1_s_M_elems_V_3", "role": "write" }} , 
 	{ "name": "xi2_s_M_elems_V_3_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_3", "role": "din" }} , 
 	{ "name": "xi2_s_M_elems_V_3_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_3", "role": "full_n" }} , 
 	{ "name": "xi2_s_M_elems_V_3_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi2_s_M_elems_V_3", "role": "write" }} , 
 	{ "name": "xi3_s_M_elems_V_3_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_3", "role": "din" }} , 
 	{ "name": "xi3_s_M_elems_V_3_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_3", "role": "full_n" }} , 
 	{ "name": "xi3_s_M_elems_V_3_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi3_s_M_elems_V_3", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "p_read", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
		xi0_s_M_elems_V_4 {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "18", "Max" : "18"}
	, {"Name" : "Interval", "Min" : "18", "Max" : "18"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_read { ap_none {  { p_read in_data 0 128 } } }
	xi3_s_M_elems_V_2 { ap_fifo {  { xi3_s_M_elems_V_2_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_2_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_2_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_6 { ap_fifo {  { xi3_s_M_elems_V_6_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_6_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_6_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_1 { ap_fifo {  { xi3_s_M_elems_V_1_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_1_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_1_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_5 { ap_fifo {  { xi3_s_M_elems_V_5_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_5_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_5_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_0 { ap_fifo {  { xi3_s_M_elems_V_0_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_0_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_0_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_4 { ap_fifo {  { xi3_s_M_elems_V_4_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_4_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_4_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_2 { ap_fifo {  { xi2_s_M_elems_V_2_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_2_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_2_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_6 { ap_fifo {  { xi2_s_M_elems_V_6_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_6_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_6_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_1 { ap_fifo {  { xi2_s_M_elems_V_1_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_1_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_1_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_5 { ap_fifo {  { xi2_s_M_elems_V_5_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_5_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_5_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_0 { ap_fifo {  { xi2_s_M_elems_V_0_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_0_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_0_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_4 { ap_fifo {  { xi2_s_M_elems_V_4_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_4_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_4_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_2 { ap_fifo {  { xi1_s_M_elems_V_2_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_2_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_2_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_6 { ap_fifo {  { xi1_s_M_elems_V_6_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_6_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_6_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_1 { ap_fifo {  { xi1_s_M_elems_V_1_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_1_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_1_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_5 { ap_fifo {  { xi1_s_M_elems_V_5_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_5_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_5_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_0 { ap_fifo {  { xi1_s_M_elems_V_0_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_0_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_0_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_4 { ap_fifo {  { xi1_s_M_elems_V_4_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_4_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_4_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_3 { ap_fifo {  { xi0_s_M_elems_V_3_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_3_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_3_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_3 { ap_fifo {  { xi1_s_M_elems_V_3_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_3_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_3_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_3 { ap_fifo {  { xi2_s_M_elems_V_3_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_3_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_3_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_3 { ap_fifo {  { xi3_s_M_elems_V_3_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_3_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_3_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_7 { ap_fifo {  { xi0_s_M_elems_V_7_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_7_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_7_write fifo_port_we 1 1 } } }
	xi1_s_M_elems_V_7 { ap_fifo {  { xi1_s_M_elems_V_7_din fifo_data_in 1 32 }  { xi1_s_M_elems_V_7_full_n fifo_status 0 1 }  { xi1_s_M_elems_V_7_write fifo_port_we 1 1 } } }
	xi2_s_M_elems_V_7 { ap_fifo {  { xi2_s_M_elems_V_7_din fifo_data_in 1 32 }  { xi2_s_M_elems_V_7_full_n fifo_status 0 1 }  { xi2_s_M_elems_V_7_write fifo_port_we 1 1 } } }
	xi3_s_M_elems_V_7 { ap_fifo {  { xi3_s_M_elems_V_7_din fifo_data_in 1 32 }  { xi3_s_M_elems_V_7_full_n fifo_status 0 1 }  { xi3_s_M_elems_V_7_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_2 { ap_fifo {  { xi0_s_M_elems_V_2_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_2_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_2_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_6 { ap_fifo {  { xi0_s_M_elems_V_6_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_6_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_6_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_1 { ap_fifo {  { xi0_s_M_elems_V_1_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_1_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_1_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_5 { ap_fifo {  { xi0_s_M_elems_V_5_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_5_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_5_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_0 { ap_fifo {  { xi0_s_M_elems_V_0_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_0_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_0_write fifo_port_we 1 1 } } }
	xi0_s_M_elems_V_4 { ap_fifo {  { xi0_s_M_elems_V_4_din fifo_data_in 1 32 }  { xi0_s_M_elems_V_4_full_n fifo_status 0 1 }  { xi0_s_M_elems_V_4_write fifo_port_we 1 1 } } }
}
