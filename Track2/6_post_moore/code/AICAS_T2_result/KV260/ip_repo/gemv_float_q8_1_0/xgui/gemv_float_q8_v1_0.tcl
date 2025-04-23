# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_M00_AXIS_SEND_START_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_CTRL_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_CTRL_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_CTRL_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_CTRL_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXIS_READX_TDATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_M00_AXIS_SEND_TDATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S01_AXIS_READW_TDATA_WIDTH" -parent ${Page_0} -widget comboBox

  ipgui::add_param $IPINST -name "GS"
  ipgui::add_param $IPINST -name "I_DIM"
  ipgui::add_param $IPINST -name "Q_WIDTH"
  ipgui::add_param $IPINST -name "S_WIDTH"
  ipgui::add_param $IPINST -name "O_DIM"

}

proc update_PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT { PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT } {
	# Procedure called to update C_M00_AXIS_SEND_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT { PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_SEND_START_COUNT
	return true
}

proc update_PARAM_VALUE.GS { PARAM_VALUE.GS } {
	# Procedure called to update GS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GS { PARAM_VALUE.GS } {
	# Procedure called to validate GS
	return true
}

proc update_PARAM_VALUE.I_DIM { PARAM_VALUE.I_DIM } {
	# Procedure called to update I_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I_DIM { PARAM_VALUE.I_DIM } {
	# Procedure called to validate I_DIM
	return true
}

proc update_PARAM_VALUE.O_DIM { PARAM_VALUE.O_DIM } {
	# Procedure called to update O_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.O_DIM { PARAM_VALUE.O_DIM } {
	# Procedure called to validate O_DIM
	return true
}

proc update_PARAM_VALUE.Q_WIDTH { PARAM_VALUE.Q_WIDTH } {
	# Procedure called to update Q_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Q_WIDTH { PARAM_VALUE.Q_WIDTH } {
	# Procedure called to validate Q_WIDTH
	return true
}

proc update_PARAM_VALUE.S_WIDTH { PARAM_VALUE.S_WIDTH } {
	# Procedure called to update S_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_WIDTH { PARAM_VALUE.S_WIDTH } {
	# Procedure called to validate S_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_CTRL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_CTRL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_CTRL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_CTRL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CTRL_BASEADDR { PARAM_VALUE.C_S00_AXI_CTRL_BASEADDR } {
	# Procedure called to update C_S00_AXI_CTRL_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CTRL_BASEADDR { PARAM_VALUE.C_S00_AXI_CTRL_BASEADDR } {
	# Procedure called to validate C_S00_AXI_CTRL_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_CTRL_HIGHADDR { PARAM_VALUE.C_S00_AXI_CTRL_HIGHADDR } {
	# Procedure called to update C_S00_AXI_CTRL_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_CTRL_HIGHADDR { PARAM_VALUE.C_S00_AXI_CTRL_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_CTRL_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_READX_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_READX_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_SEND_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_SEND_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH { PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH } {
	# Procedure called to update C_S01_AXIS_READW_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH { PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH } {
	# Procedure called to validate C_S01_AXIS_READW_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_CTRL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_CTRL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_READX_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_SEND_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_SEND_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_SEND_START_COUNT PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_SEND_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_SEND_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH { MODELPARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S01_AXIS_READW_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.Q_WIDTH { MODELPARAM_VALUE.Q_WIDTH PARAM_VALUE.Q_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Q_WIDTH}] ${MODELPARAM_VALUE.Q_WIDTH}
}

proc update_MODELPARAM_VALUE.S_WIDTH { MODELPARAM_VALUE.S_WIDTH PARAM_VALUE.S_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_WIDTH}] ${MODELPARAM_VALUE.S_WIDTH}
}

proc update_MODELPARAM_VALUE.GS { MODELPARAM_VALUE.GS PARAM_VALUE.GS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GS}] ${MODELPARAM_VALUE.GS}
}

proc update_MODELPARAM_VALUE.I_DIM { MODELPARAM_VALUE.I_DIM PARAM_VALUE.I_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I_DIM}] ${MODELPARAM_VALUE.I_DIM}
}

proc update_MODELPARAM_VALUE.O_DIM { MODELPARAM_VALUE.O_DIM PARAM_VALUE.O_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.O_DIM}] ${MODELPARAM_VALUE.O_DIM}
}

