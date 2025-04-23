# Vitis HLS Project for Xilinx KV260

This project demonstrates a High-Level Synthesis (HLS) workflow targeting the **Xilinx KV260 FPGA** using Vitis HLS 2022.1+.

## Directory Structure

kv260_hls_project/
├── script/ # TCL scripts for automation
├── log/ # Auto-generated logs
├── src/ # Design source files
├── tb/ # Testbench files
└── README.md # This documentation

## Scripts

| Script          | Description                                  |
|-----------------|----------------------------------------------|
| `config.tcl`    | Global configurations (device, paths, etc.)  |
| `csynth.tcl`    | Synthesize the HLS design                    |
| `run_csim.tcl`  | Run C simulation for functional validation   |
| `run_cosim.tcl` | Run RTL co-simulation with XSIM              |
| `export.tcl`    | Export IP to Vivado-compatible format        |

## How to Run

### 1. Synthesis
```bash
vitis_hls -f script/csynth.tcl | tee log/csynth.log
```
### 2. C Simulation
```bash
vitis_hls -f script/csynth.tcl | tee log/csynth.log
```

### 3. RTL Co-Simulation
```
vitis_hls -f script/run_cosim.tcl | tee log/cosim.log
```

### 4. IP Export
```
vitis_hls -f script/export.tcl | tee log/export.log
```

### Makefile
The above cmds are supported by the Makefile:
```
csim :
	vitis_hls -f script/run_csim.tcl | tee log/csim.log
csynth :
	vitis_hls -f script/csynth.tcl | tee log/csynth.log
cosim :
	vitis_hls -f script/run_cosim.tcl | tee log/cosim.log
genip :
	vitis_hls -f script/export.tcl | tee log/export.log

```

## KeyNotes

## Config
To get start with a new project, please re-write the variable in `./script/config.tcl`

## FPGA Device:

Target device is xczu3eg-sfvc784-1-e (KV260).

## Debugging:

Co-simulation generates waveforms in <project>/<solution>/sim/verilog.

##  Dependencies:

Ensure Vitis HLS 2024.2+ and XSIM are installed.