set ModuleHierarchy {[{
"Name" : "Macro_MAC_Acc4_top","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "entry_proc_U0","ID" : "1","Type" : "sequential"},
	{"Name" : "Loop_VITIS_LOOP_324_2_proc_U0","ID" : "2","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_324_2","ID" : "3","Type" : "no",
		"SubInsts" : [
		{"Name" : "grp_read_xi_to_stream_fu_1054","ID" : "4","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_116_1","ID" : "5","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_1_fu_1123","ID" : "6","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_146_1","ID" : "7","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_11_fu_1143","ID" : "8","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_146_1","ID" : "9","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_13_fu_1163","ID" : "10","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_146_1","ID" : "11","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_146_15_fu_1183","ID" : "12","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_146_1","ID" : "13","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_2_fu_1203","ID" : "14","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_154_2","ID" : "15","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_22_fu_1227","ID" : "16","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_154_2","ID" : "17","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_24_fu_1251","ID" : "18","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_154_2","ID" : "19","Type" : "pipeline"},]},
		{"Name" : "grp_Loop_VITIS_LOOP_324_2_proc_Pipeline_VITIS_LOOP_154_26_fu_1275","ID" : "20","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_154_2","ID" : "21","Type" : "pipeline"},]},
		{"Name" : "grp_compute_mac_fu_1299","ID" : "22","Type" : "sequential",
				"SubInsts" : [
				{"Name" : "grp_compute_mac_sub_fu_360","ID" : "23","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "24","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_400","ID" : "25","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "26","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_440","ID" : "27","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "28","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_480","ID" : "29","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "30","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_520","ID" : "31","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "32","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_560","ID" : "33","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "34","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_600","ID" : "35","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "36","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_640","ID" : "37","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "38","Type" : "pipeline"},]},],
				"SubLoops" : [
				{"Name" : "lp_cmp_mac_cplocal","ID" : "39","Type" : "pipeline"},]},
		{"Name" : "grp_compute_mac_fu_1359","ID" : "40","Type" : "sequential",
				"SubInsts" : [
				{"Name" : "grp_compute_mac_sub_fu_360","ID" : "41","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "42","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_400","ID" : "43","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "44","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_440","ID" : "45","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "46","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_480","ID" : "47","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "48","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_520","ID" : "49","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "50","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_560","ID" : "51","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "52","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_600","ID" : "53","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "54","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_640","ID" : "55","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "56","Type" : "pipeline"},]},],
				"SubLoops" : [
				{"Name" : "lp_cmp_mac_cplocal","ID" : "57","Type" : "pipeline"},]},
		{"Name" : "grp_compute_mac_fu_1419","ID" : "58","Type" : "sequential",
				"SubInsts" : [
				{"Name" : "grp_compute_mac_sub_fu_360","ID" : "59","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "60","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_400","ID" : "61","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "62","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_440","ID" : "63","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "64","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_480","ID" : "65","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "66","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_520","ID" : "67","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "68","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_560","ID" : "69","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "70","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_600","ID" : "71","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "72","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_640","ID" : "73","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "74","Type" : "pipeline"},]},],
				"SubLoops" : [
				{"Name" : "lp_cmp_mac_cplocal","ID" : "75","Type" : "pipeline"},]},
		{"Name" : "grp_compute_mac_fu_1479","ID" : "76","Type" : "sequential",
				"SubInsts" : [
				{"Name" : "grp_compute_mac_sub_fu_360","ID" : "77","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "78","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_400","ID" : "79","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "80","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_440","ID" : "81","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "82","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_480","ID" : "83","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "84","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_520","ID" : "85","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "86","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_560","ID" : "87","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "88","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_600","ID" : "89","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "90","Type" : "pipeline"},]},
				{"Name" : "grp_compute_mac_sub_fu_640","ID" : "91","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "lp_cmp_sub_h","ID" : "92","Type" : "pipeline"},]},],
				"SubLoops" : [
				{"Name" : "lp_cmp_mac_cplocal","ID" : "93","Type" : "pipeline"},]},]},]},
	{"Name" : "Loop_VITIS_LOOP_337_3_proc_U0","ID" : "94","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_337_3_VITIS_LOOP_338_4","ID" : "95","Type" : "pipeline"},]},]
}]}