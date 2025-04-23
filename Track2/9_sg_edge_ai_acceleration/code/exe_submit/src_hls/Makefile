.PHONY: help csim csynth cosim genip clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@echo "  csim    : Run C simulation using script/run_csim.tcl (log saved to log/csim.log)"
	@echo "  csynth  : Run C synthesis using script/csynth.tcl (log saved to log/csynth.log)"
	@echo "  cosim   : Run C cosimulation using script/run_cosim.tcl (log saved to log/cosim.log)"
	@echo "  genip   : Generate IP repository using script/export.tcl (log saved to log/export.log)"
	@echo "  clean   : Remove ip_repo.zip and prjhls_* directories"

csim:
	vitis_hls -f script/run_csim.tcl | tee log/csim.log

csynth:
	vitis_hls -f script/csynth.tcl | tee log/csynth.log

cosim:
	vitis_hls -f script/run_cosim.tcl | tee log/cosim.log

genip:
	vitis_hls -f script/export.tcl | tee log/export.log

clean:
	rm -f ip_repo.zip
	rm -rf prjhls_*