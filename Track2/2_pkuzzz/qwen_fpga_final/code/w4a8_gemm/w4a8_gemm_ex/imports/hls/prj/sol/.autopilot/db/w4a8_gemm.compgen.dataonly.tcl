# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
scalar00 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 16
	offset_end 23
}
scalar01 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 24
	offset_end 31
}
scalar02 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 32
	offset_end 39
}
scalar03 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 40
	offset_end 47
}
axi00_ptr0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 48
	offset_end 59
}
axi01_ptr0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 60
	offset_end 71
}
axi02_ptr0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 72
	offset_end 83
}
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
interrupt {
}
}
dict set axilite_register_dict control $port_control


