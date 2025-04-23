#include "xaxicdma.h"

XAxiCdma_Config XAxiCdma_ConfigTable[] __attribute__ ((section (".drvcfg_sec"))) = {

	{
		"xlnx,axi-cdma-4.1", /* compatible */
		0xa0010000, /* reg */
		0x0, /* xlnx,include-dre */
		0x0, /* xlnx,lite-mode */
		0x200, /* xlnx,datawidth */
		0x40, /* xlnx,max-burst-len */
		0x20, /* xlnx,addrwidth */
		0xffff, /* interrupts */
		0xffff, /* interrupt-parent */
		0x1 /* xlnx,include-sg */
	},
	 {
		 NULL
	}
};