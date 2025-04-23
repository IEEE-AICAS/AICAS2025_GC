set moduleName compute_mac
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
set C_modelName {compute_mac}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ xi_s_0_0 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_01 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_02 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_03 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_04 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_05 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_06 float 32 regular {fifo 0 volatile }  }
	{ xi_s_0_07 float 32 regular {fifo 0 volatile }  }
	{ mro_s_0_0 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_08 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_09 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_010 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_011 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_012 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_013 int 32 regular {fifo 0 volatile }  }
	{ mro_s_0_014 int 32 regular {fifo 0 volatile }  }
	{ qzeros_0_val8 int 4 regular  }
	{ qzeros_1_val16 int 4 regular  }
	{ qzeros_2_val24 int 4 regular  }
	{ qzeros_3_val32 int 4 regular  }
	{ qzeros_4_val40 int 4 regular  }
	{ qzeros_5_val48 int 4 regular  }
	{ qzeros_6_val56 int 4 regular  }
	{ qzeros_7_val64 int 4 regular  }
	{ qscale_0_val72 float 32 regular  }
	{ qscale_1_val81 float 32 regular  }
	{ qscale_2_val89 float 32 regular  }
	{ qscale_3_val98 float 32 regular  }
	{ qscale_4_val106 float 32 regular  }
	{ qscale_5_val115 float 32 regular  }
	{ qscale_6_val123 float 32 regular  }
	{ qscale_7_val132 float 32 regular  }
	{ pout_local_0 float 32 regular {pointer 2}  }
	{ pout_local_1 float 32 regular {pointer 2}  }
	{ pout_local_2 float 32 regular {pointer 2}  }
	{ pout_local_3 float 32 regular {pointer 2}  }
	{ pout_local_4 float 32 regular {pointer 2}  }
	{ pout_local_5 float 32 regular {pointer 2}  }
	{ pout_local_6 float 32 regular {pointer 2}  }
	{ pout_local_7 float 32 regular {pointer 2}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "xi_s_0_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_01", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_02", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_03", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_04", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_05", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_06", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "xi_s_0_07", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_0", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_08", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_09", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_010", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_011", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_012", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_013", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mro_s_0_014", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_0_val8", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_1_val16", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_2_val24", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_3_val32", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_4_val40", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_5_val48", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_6_val56", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qzeros_7_val64", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_0_val72", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_1_val81", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_2_val89", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_3_val98", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_4_val106", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_5_val115", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_6_val123", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "qscale_7_val132", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "pout_local_0", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_1", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_2", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_3", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_4", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_5", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_6", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "pout_local_7", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} ]}
# RTL Port declarations: 
set portNum 94
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ xi_s_0_0_dout sc_in sc_lv 32 signal 0 } 
	{ xi_s_0_0_empty_n sc_in sc_logic 1 signal 0 } 
	{ xi_s_0_0_read sc_out sc_logic 1 signal 0 } 
	{ xi_s_0_01_dout sc_in sc_lv 32 signal 1 } 
	{ xi_s_0_01_empty_n sc_in sc_logic 1 signal 1 } 
	{ xi_s_0_01_read sc_out sc_logic 1 signal 1 } 
	{ xi_s_0_02_dout sc_in sc_lv 32 signal 2 } 
	{ xi_s_0_02_empty_n sc_in sc_logic 1 signal 2 } 
	{ xi_s_0_02_read sc_out sc_logic 1 signal 2 } 
	{ xi_s_0_03_dout sc_in sc_lv 32 signal 3 } 
	{ xi_s_0_03_empty_n sc_in sc_logic 1 signal 3 } 
	{ xi_s_0_03_read sc_out sc_logic 1 signal 3 } 
	{ xi_s_0_04_dout sc_in sc_lv 32 signal 4 } 
	{ xi_s_0_04_empty_n sc_in sc_logic 1 signal 4 } 
	{ xi_s_0_04_read sc_out sc_logic 1 signal 4 } 
	{ xi_s_0_05_dout sc_in sc_lv 32 signal 5 } 
	{ xi_s_0_05_empty_n sc_in sc_logic 1 signal 5 } 
	{ xi_s_0_05_read sc_out sc_logic 1 signal 5 } 
	{ xi_s_0_06_dout sc_in sc_lv 32 signal 6 } 
	{ xi_s_0_06_empty_n sc_in sc_logic 1 signal 6 } 
	{ xi_s_0_06_read sc_out sc_logic 1 signal 6 } 
	{ xi_s_0_07_dout sc_in sc_lv 32 signal 7 } 
	{ xi_s_0_07_empty_n sc_in sc_logic 1 signal 7 } 
	{ xi_s_0_07_read sc_out sc_logic 1 signal 7 } 
	{ mro_s_0_0_dout sc_in sc_lv 32 signal 8 } 
	{ mro_s_0_0_empty_n sc_in sc_logic 1 signal 8 } 
	{ mro_s_0_0_read sc_out sc_logic 1 signal 8 } 
	{ mro_s_0_08_dout sc_in sc_lv 32 signal 9 } 
	{ mro_s_0_08_empty_n sc_in sc_logic 1 signal 9 } 
	{ mro_s_0_08_read sc_out sc_logic 1 signal 9 } 
	{ mro_s_0_09_dout sc_in sc_lv 32 signal 10 } 
	{ mro_s_0_09_empty_n sc_in sc_logic 1 signal 10 } 
	{ mro_s_0_09_read sc_out sc_logic 1 signal 10 } 
	{ mro_s_0_010_dout sc_in sc_lv 32 signal 11 } 
	{ mro_s_0_010_empty_n sc_in sc_logic 1 signal 11 } 
	{ mro_s_0_010_read sc_out sc_logic 1 signal 11 } 
	{ mro_s_0_011_dout sc_in sc_lv 32 signal 12 } 
	{ mro_s_0_011_empty_n sc_in sc_logic 1 signal 12 } 
	{ mro_s_0_011_read sc_out sc_logic 1 signal 12 } 
	{ mro_s_0_012_dout sc_in sc_lv 32 signal 13 } 
	{ mro_s_0_012_empty_n sc_in sc_logic 1 signal 13 } 
	{ mro_s_0_012_read sc_out sc_logic 1 signal 13 } 
	{ mro_s_0_013_dout sc_in sc_lv 32 signal 14 } 
	{ mro_s_0_013_empty_n sc_in sc_logic 1 signal 14 } 
	{ mro_s_0_013_read sc_out sc_logic 1 signal 14 } 
	{ mro_s_0_014_dout sc_in sc_lv 32 signal 15 } 
	{ mro_s_0_014_empty_n sc_in sc_logic 1 signal 15 } 
	{ mro_s_0_014_read sc_out sc_logic 1 signal 15 } 
	{ qzeros_0_val8 sc_in sc_lv 4 signal 16 } 
	{ qzeros_1_val16 sc_in sc_lv 4 signal 17 } 
	{ qzeros_2_val24 sc_in sc_lv 4 signal 18 } 
	{ qzeros_3_val32 sc_in sc_lv 4 signal 19 } 
	{ qzeros_4_val40 sc_in sc_lv 4 signal 20 } 
	{ qzeros_5_val48 sc_in sc_lv 4 signal 21 } 
	{ qzeros_6_val56 sc_in sc_lv 4 signal 22 } 
	{ qzeros_7_val64 sc_in sc_lv 4 signal 23 } 
	{ qscale_0_val72 sc_in sc_lv 32 signal 24 } 
	{ qscale_1_val81 sc_in sc_lv 32 signal 25 } 
	{ qscale_2_val89 sc_in sc_lv 32 signal 26 } 
	{ qscale_3_val98 sc_in sc_lv 32 signal 27 } 
	{ qscale_4_val106 sc_in sc_lv 32 signal 28 } 
	{ qscale_5_val115 sc_in sc_lv 32 signal 29 } 
	{ qscale_6_val123 sc_in sc_lv 32 signal 30 } 
	{ qscale_7_val132 sc_in sc_lv 32 signal 31 } 
	{ pout_local_0_i sc_in sc_lv 32 signal 32 } 
	{ pout_local_0_o sc_out sc_lv 32 signal 32 } 
	{ pout_local_0_o_ap_vld sc_out sc_logic 1 outvld 32 } 
	{ pout_local_1_i sc_in sc_lv 32 signal 33 } 
	{ pout_local_1_o sc_out sc_lv 32 signal 33 } 
	{ pout_local_1_o_ap_vld sc_out sc_logic 1 outvld 33 } 
	{ pout_local_2_i sc_in sc_lv 32 signal 34 } 
	{ pout_local_2_o sc_out sc_lv 32 signal 34 } 
	{ pout_local_2_o_ap_vld sc_out sc_logic 1 outvld 34 } 
	{ pout_local_3_i sc_in sc_lv 32 signal 35 } 
	{ pout_local_3_o sc_out sc_lv 32 signal 35 } 
	{ pout_local_3_o_ap_vld sc_out sc_logic 1 outvld 35 } 
	{ pout_local_4_i sc_in sc_lv 32 signal 36 } 
	{ pout_local_4_o sc_out sc_lv 32 signal 36 } 
	{ pout_local_4_o_ap_vld sc_out sc_logic 1 outvld 36 } 
	{ pout_local_5_i sc_in sc_lv 32 signal 37 } 
	{ pout_local_5_o sc_out sc_lv 32 signal 37 } 
	{ pout_local_5_o_ap_vld sc_out sc_logic 1 outvld 37 } 
	{ pout_local_6_i sc_in sc_lv 32 signal 38 } 
	{ pout_local_6_o sc_out sc_lv 32 signal 38 } 
	{ pout_local_6_o_ap_vld sc_out sc_logic 1 outvld 38 } 
	{ pout_local_7_i sc_in sc_lv 32 signal 39 } 
	{ pout_local_7_o sc_out sc_lv 32 signal 39 } 
	{ pout_local_7_o_ap_vld sc_out sc_logic 1 outvld 39 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "xi_s_0_0_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_0", "role": "dout" }} , 
 	{ "name": "xi_s_0_0_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_0", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_0_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_0", "role": "read" }} , 
 	{ "name": "xi_s_0_01_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_01", "role": "dout" }} , 
 	{ "name": "xi_s_0_01_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_01", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_01_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_01", "role": "read" }} , 
 	{ "name": "xi_s_0_02_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_02", "role": "dout" }} , 
 	{ "name": "xi_s_0_02_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_02", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_02_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_02", "role": "read" }} , 
 	{ "name": "xi_s_0_03_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_03", "role": "dout" }} , 
 	{ "name": "xi_s_0_03_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_03", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_03_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_03", "role": "read" }} , 
 	{ "name": "xi_s_0_04_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_04", "role": "dout" }} , 
 	{ "name": "xi_s_0_04_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_04", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_04_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_04", "role": "read" }} , 
 	{ "name": "xi_s_0_05_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_05", "role": "dout" }} , 
 	{ "name": "xi_s_0_05_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_05", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_05_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_05", "role": "read" }} , 
 	{ "name": "xi_s_0_06_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_06", "role": "dout" }} , 
 	{ "name": "xi_s_0_06_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_06", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_06_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_06", "role": "read" }} , 
 	{ "name": "xi_s_0_07_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "xi_s_0_07", "role": "dout" }} , 
 	{ "name": "xi_s_0_07_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_07", "role": "empty_n" }} , 
 	{ "name": "xi_s_0_07_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xi_s_0_07", "role": "read" }} , 
 	{ "name": "mro_s_0_0_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_0", "role": "dout" }} , 
 	{ "name": "mro_s_0_0_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_0", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_0_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_0", "role": "read" }} , 
 	{ "name": "mro_s_0_08_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_08", "role": "dout" }} , 
 	{ "name": "mro_s_0_08_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_08", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_08_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_08", "role": "read" }} , 
 	{ "name": "mro_s_0_09_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_09", "role": "dout" }} , 
 	{ "name": "mro_s_0_09_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_09", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_09_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_09", "role": "read" }} , 
 	{ "name": "mro_s_0_010_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_010", "role": "dout" }} , 
 	{ "name": "mro_s_0_010_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_010", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_010_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_010", "role": "read" }} , 
 	{ "name": "mro_s_0_011_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_011", "role": "dout" }} , 
 	{ "name": "mro_s_0_011_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_011", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_011_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_011", "role": "read" }} , 
 	{ "name": "mro_s_0_012_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_012", "role": "dout" }} , 
 	{ "name": "mro_s_0_012_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_012", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_012_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_012", "role": "read" }} , 
 	{ "name": "mro_s_0_013_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_013", "role": "dout" }} , 
 	{ "name": "mro_s_0_013_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_013", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_013_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_013", "role": "read" }} , 
 	{ "name": "mro_s_0_014_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mro_s_0_014", "role": "dout" }} , 
 	{ "name": "mro_s_0_014_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_014", "role": "empty_n" }} , 
 	{ "name": "mro_s_0_014_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mro_s_0_014", "role": "read" }} , 
 	{ "name": "qzeros_0_val8", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_0_val8", "role": "default" }} , 
 	{ "name": "qzeros_1_val16", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_1_val16", "role": "default" }} , 
 	{ "name": "qzeros_2_val24", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_2_val24", "role": "default" }} , 
 	{ "name": "qzeros_3_val32", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_3_val32", "role": "default" }} , 
 	{ "name": "qzeros_4_val40", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_4_val40", "role": "default" }} , 
 	{ "name": "qzeros_5_val48", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_5_val48", "role": "default" }} , 
 	{ "name": "qzeros_6_val56", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_6_val56", "role": "default" }} , 
 	{ "name": "qzeros_7_val64", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "qzeros_7_val64", "role": "default" }} , 
 	{ "name": "qscale_0_val72", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_0_val72", "role": "default" }} , 
 	{ "name": "qscale_1_val81", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_1_val81", "role": "default" }} , 
 	{ "name": "qscale_2_val89", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_2_val89", "role": "default" }} , 
 	{ "name": "qscale_3_val98", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_3_val98", "role": "default" }} , 
 	{ "name": "qscale_4_val106", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_4_val106", "role": "default" }} , 
 	{ "name": "qscale_5_val115", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_5_val115", "role": "default" }} , 
 	{ "name": "qscale_6_val123", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_6_val123", "role": "default" }} , 
 	{ "name": "qscale_7_val132", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "qscale_7_val132", "role": "default" }} , 
 	{ "name": "pout_local_0_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_0", "role": "i" }} , 
 	{ "name": "pout_local_0_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_0", "role": "o" }} , 
 	{ "name": "pout_local_0_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_0", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_1_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_1", "role": "i" }} , 
 	{ "name": "pout_local_1_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_1", "role": "o" }} , 
 	{ "name": "pout_local_1_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_1", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_2_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_2", "role": "i" }} , 
 	{ "name": "pout_local_2_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_2", "role": "o" }} , 
 	{ "name": "pout_local_2_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_2", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_3_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_3", "role": "i" }} , 
 	{ "name": "pout_local_3_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_3", "role": "o" }} , 
 	{ "name": "pout_local_3_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_3", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_4_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_4", "role": "i" }} , 
 	{ "name": "pout_local_4_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_4", "role": "o" }} , 
 	{ "name": "pout_local_4_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_4", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_5_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_5", "role": "i" }} , 
 	{ "name": "pout_local_5_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_5", "role": "o" }} , 
 	{ "name": "pout_local_5_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_5", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_6_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_6", "role": "i" }} , 
 	{ "name": "pout_local_6_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_6", "role": "o" }} , 
 	{ "name": "pout_local_6_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_6", "role": "o_ap_vld" }} , 
 	{ "name": "pout_local_7_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_7", "role": "i" }} , 
 	{ "name": "pout_local_7_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pout_local_7", "role": "o" }} , 
 	{ "name": "pout_local_7_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "pout_local_7", "role": "o_ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "11", "21", "31", "41", "51", "61", "71", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97"],
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
					{"ID" : "1", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_01", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_02", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_03", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_04", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "41", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_05", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_06", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "xi_s_0_07", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "71", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "xi_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_0", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_compute_mac_sub_fu_360", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_08", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "11", "SubInstance" : "grp_compute_mac_sub_fu_400", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_09", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "grp_compute_mac_sub_fu_440", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_010", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_compute_mac_sub_fu_480", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_011", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "41", "SubInstance" : "grp_compute_mac_sub_fu_520", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_012", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "grp_compute_mac_sub_fu_560", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_013", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_compute_mac_sub_fu_600", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "mro_s_0_014", "Type" : "Fifo", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "71", "SubInstance" : "grp_compute_mac_sub_fu_640", "Port" : "mro_s_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "10"],
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
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "1"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_360.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400", "Parent" : "0", "Child" : ["12", "13", "14", "15", "16", "17", "18", "19", "20"],
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
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "11"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "11"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "11"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "11"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "11"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "11"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "11"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "11"},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_400.flow_control_loop_pipe_sequential_init_U", "Parent" : "11"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440", "Parent" : "0", "Child" : ["22", "23", "24", "25", "26", "27", "28", "29", "30"],
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
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "21"},
	{"ID" : "23", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "21"},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "21"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "21"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "21"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "21"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "21"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "21"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_440.flow_control_loop_pipe_sequential_init_U", "Parent" : "21"},
	{"ID" : "31", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480", "Parent" : "0", "Child" : ["32", "33", "34", "35", "36", "37", "38", "39", "40"],
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
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "31"},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "31"},
	{"ID" : "34", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "31"},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "31"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "31"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "31"},
	{"ID" : "38", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "31"},
	{"ID" : "39", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "31"},
	{"ID" : "40", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_480.flow_control_loop_pipe_sequential_init_U", "Parent" : "31"},
	{"ID" : "41", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520", "Parent" : "0", "Child" : ["42", "43", "44", "45", "46", "47", "48", "49", "50"],
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
	{"ID" : "42", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "41"},
	{"ID" : "43", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "41"},
	{"ID" : "44", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "41"},
	{"ID" : "45", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "41"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "41"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "41"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "41"},
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "41"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_520.flow_control_loop_pipe_sequential_init_U", "Parent" : "41"},
	{"ID" : "51", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560", "Parent" : "0", "Child" : ["52", "53", "54", "55", "56", "57", "58", "59", "60"],
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
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "51"},
	{"ID" : "53", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "51"},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "51"},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "51"},
	{"ID" : "56", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "51"},
	{"ID" : "57", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "51"},
	{"ID" : "58", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "51"},
	{"ID" : "59", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "51"},
	{"ID" : "60", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_560.flow_control_loop_pipe_sequential_init_U", "Parent" : "51"},
	{"ID" : "61", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600", "Parent" : "0", "Child" : ["62", "63", "64", "65", "66", "67", "68", "69", "70"],
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
	{"ID" : "62", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "61"},
	{"ID" : "63", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "61"},
	{"ID" : "64", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "61"},
	{"ID" : "65", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "61"},
	{"ID" : "66", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "61"},
	{"ID" : "67", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "61"},
	{"ID" : "68", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "61"},
	{"ID" : "69", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "61"},
	{"ID" : "70", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_600.flow_control_loop_pipe_sequential_init_U", "Parent" : "61"},
	{"ID" : "71", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640", "Parent" : "0", "Child" : ["72", "73", "74", "75", "76", "77", "78", "79", "80"],
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
	{"ID" : "72", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U158", "Parent" : "71"},
	{"ID" : "73", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fadd_32ns_32ns_32_6_no_dsp_1_U159", "Parent" : "71"},
	{"ID" : "74", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U160", "Parent" : "71"},
	{"ID" : "75", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U161", "Parent" : "71"},
	{"ID" : "76", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U162", "Parent" : "71"},
	{"ID" : "77", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.fmul_32ns_32ns_32_5_max_dsp_1_U163", "Parent" : "71"},
	{"ID" : "78", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U164", "Parent" : "71"},
	{"ID" : "79", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.sitofp_32s_32_6_no_dsp_1_U165", "Parent" : "71"},
	{"ID" : "80", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_compute_mac_sub_fu_640.flow_control_loop_pipe_sequential_init_U", "Parent" : "71"},
	{"ID" : "81", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U187", "Parent" : "0"},
	{"ID" : "82", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U188", "Parent" : "0"},
	{"ID" : "83", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U189", "Parent" : "0"},
	{"ID" : "84", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U190", "Parent" : "0"},
	{"ID" : "85", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U191", "Parent" : "0"},
	{"ID" : "86", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U192", "Parent" : "0"},
	{"ID" : "87", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U193", "Parent" : "0"},
	{"ID" : "88", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.fadd_32ns_32ns_32_6_no_dsp_1_U194", "Parent" : "0"},
	{"ID" : "89", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U195", "Parent" : "0"},
	{"ID" : "90", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U196", "Parent" : "0"},
	{"ID" : "91", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U197", "Parent" : "0"},
	{"ID" : "92", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U198", "Parent" : "0"},
	{"ID" : "93", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U199", "Parent" : "0"},
	{"ID" : "94", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U200", "Parent" : "0"},
	{"ID" : "95", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U201", "Parent" : "0"},
	{"ID" : "96", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U202", "Parent" : "0"},
	{"ID" : "97", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_17_3_32_1_1_U203", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
	{"Name" : "Latency", "Min" : "93", "Max" : "93"}
	, {"Name" : "Interval", "Min" : "93", "Max" : "93"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	xi_s_0_0 { ap_fifo {  { xi_s_0_0_dout fifo_data_in 0 32 }  { xi_s_0_0_empty_n fifo_status 0 1 }  { xi_s_0_0_read fifo_port_we 1 1 } } }
	xi_s_0_01 { ap_fifo {  { xi_s_0_01_dout fifo_data_in 0 32 }  { xi_s_0_01_empty_n fifo_status 0 1 }  { xi_s_0_01_read fifo_port_we 1 1 } } }
	xi_s_0_02 { ap_fifo {  { xi_s_0_02_dout fifo_data_in 0 32 }  { xi_s_0_02_empty_n fifo_status 0 1 }  { xi_s_0_02_read fifo_port_we 1 1 } } }
	xi_s_0_03 { ap_fifo {  { xi_s_0_03_dout fifo_data_in 0 32 }  { xi_s_0_03_empty_n fifo_status 0 1 }  { xi_s_0_03_read fifo_port_we 1 1 } } }
	xi_s_0_04 { ap_fifo {  { xi_s_0_04_dout fifo_data_in 0 32 }  { xi_s_0_04_empty_n fifo_status 0 1 }  { xi_s_0_04_read fifo_port_we 1 1 } } }
	xi_s_0_05 { ap_fifo {  { xi_s_0_05_dout fifo_data_in 0 32 }  { xi_s_0_05_empty_n fifo_status 0 1 }  { xi_s_0_05_read fifo_port_we 1 1 } } }
	xi_s_0_06 { ap_fifo {  { xi_s_0_06_dout fifo_data_in 0 32 }  { xi_s_0_06_empty_n fifo_status 0 1 }  { xi_s_0_06_read fifo_port_we 1 1 } } }
	xi_s_0_07 { ap_fifo {  { xi_s_0_07_dout fifo_data_in 0 32 }  { xi_s_0_07_empty_n fifo_status 0 1 }  { xi_s_0_07_read fifo_port_we 1 1 } } }
	mro_s_0_0 { ap_fifo {  { mro_s_0_0_dout fifo_data_in 0 32 }  { mro_s_0_0_empty_n fifo_status 0 1 }  { mro_s_0_0_read fifo_port_we 1 1 } } }
	mro_s_0_08 { ap_fifo {  { mro_s_0_08_dout fifo_data_in 0 32 }  { mro_s_0_08_empty_n fifo_status 0 1 }  { mro_s_0_08_read fifo_port_we 1 1 } } }
	mro_s_0_09 { ap_fifo {  { mro_s_0_09_dout fifo_data_in 0 32 }  { mro_s_0_09_empty_n fifo_status 0 1 }  { mro_s_0_09_read fifo_port_we 1 1 } } }
	mro_s_0_010 { ap_fifo {  { mro_s_0_010_dout fifo_data_in 0 32 }  { mro_s_0_010_empty_n fifo_status 0 1 }  { mro_s_0_010_read fifo_port_we 1 1 } } }
	mro_s_0_011 { ap_fifo {  { mro_s_0_011_dout fifo_data_in 0 32 }  { mro_s_0_011_empty_n fifo_status 0 1 }  { mro_s_0_011_read fifo_port_we 1 1 } } }
	mro_s_0_012 { ap_fifo {  { mro_s_0_012_dout fifo_data_in 0 32 }  { mro_s_0_012_empty_n fifo_status 0 1 }  { mro_s_0_012_read fifo_port_we 1 1 } } }
	mro_s_0_013 { ap_fifo {  { mro_s_0_013_dout fifo_data_in 0 32 }  { mro_s_0_013_empty_n fifo_status 0 1 }  { mro_s_0_013_read fifo_port_we 1 1 } } }
	mro_s_0_014 { ap_fifo {  { mro_s_0_014_dout fifo_data_in 0 32 }  { mro_s_0_014_empty_n fifo_status 0 1 }  { mro_s_0_014_read fifo_port_we 1 1 } } }
	qzeros_0_val8 { ap_none {  { qzeros_0_val8 in_data 0 4 } } }
	qzeros_1_val16 { ap_none {  { qzeros_1_val16 in_data 0 4 } } }
	qzeros_2_val24 { ap_none {  { qzeros_2_val24 in_data 0 4 } } }
	qzeros_3_val32 { ap_none {  { qzeros_3_val32 in_data 0 4 } } }
	qzeros_4_val40 { ap_none {  { qzeros_4_val40 in_data 0 4 } } }
	qzeros_5_val48 { ap_none {  { qzeros_5_val48 in_data 0 4 } } }
	qzeros_6_val56 { ap_none {  { qzeros_6_val56 in_data 0 4 } } }
	qzeros_7_val64 { ap_none {  { qzeros_7_val64 in_data 0 4 } } }
	qscale_0_val72 { ap_none {  { qscale_0_val72 in_data 0 32 } } }
	qscale_1_val81 { ap_none {  { qscale_1_val81 in_data 0 32 } } }
	qscale_2_val89 { ap_none {  { qscale_2_val89 in_data 0 32 } } }
	qscale_3_val98 { ap_none {  { qscale_3_val98 in_data 0 32 } } }
	qscale_4_val106 { ap_none {  { qscale_4_val106 in_data 0 32 } } }
	qscale_5_val115 { ap_none {  { qscale_5_val115 in_data 0 32 } } }
	qscale_6_val123 { ap_none {  { qscale_6_val123 in_data 0 32 } } }
	qscale_7_val132 { ap_none {  { qscale_7_val132 in_data 0 32 } } }
	pout_local_0 { ap_ovld {  { pout_local_0_i in_data 0 32 }  { pout_local_0_o out_data 1 32 }  { pout_local_0_o_ap_vld out_vld 1 1 } } }
	pout_local_1 { ap_ovld {  { pout_local_1_i in_data 0 32 }  { pout_local_1_o out_data 1 32 }  { pout_local_1_o_ap_vld out_vld 1 1 } } }
	pout_local_2 { ap_ovld {  { pout_local_2_i in_data 0 32 }  { pout_local_2_o out_data 1 32 }  { pout_local_2_o_ap_vld out_vld 1 1 } } }
	pout_local_3 { ap_ovld {  { pout_local_3_i in_data 0 32 }  { pout_local_3_o out_data 1 32 }  { pout_local_3_o_ap_vld out_vld 1 1 } } }
	pout_local_4 { ap_ovld {  { pout_local_4_i in_data 0 32 }  { pout_local_4_o out_data 1 32 }  { pout_local_4_o_ap_vld out_vld 1 1 } } }
	pout_local_5 { ap_ovld {  { pout_local_5_i in_data 0 32 }  { pout_local_5_o out_data 1 32 }  { pout_local_5_o_ap_vld out_vld 1 1 } } }
	pout_local_6 { ap_ovld {  { pout_local_6_i in_data 0 32 }  { pout_local_6_o out_data 1 32 }  { pout_local_6_o_ap_vld out_vld 1 1 } } }
	pout_local_7 { ap_ovld {  { pout_local_7_i in_data 0 32 }  { pout_local_7_o out_data 1 32 }  { pout_local_7_o_ap_vld out_vld 1 1 } } }
}
