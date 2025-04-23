#include<sys/mman.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdint.h>
#include<sys/ioctl.h>
#include<time.h>
#include<string.h>

#include"include/xparameters.h"
#include"include/xil_io.h"
#include"include/xaxicdma.h"
#include"include/xaxicdma_hw.h"
#include"include/xaxicdma_i.h"
#include"include/xil_printf.h"

#define MAP_REG_BASEADDR (XPAR_REGFILE_WRAPPER_0_BASEADDR)
#define MAP_REG_DEPTH (XPAR_REGFILE_WRAPPER_0_HIGHADDR+1-XPAR_REGFILE_WRAPPER_0_BASEADDR)
#define MAP_CDMA_BASEADDR (XPAR_XAXICDMA_0_BASEADDR)
#define MAP_CDMA_DEPTH (XPAR_XAXICDMA_0_HIGHADDR+1-XPAR_XAXICDMA_0_BASEADDR)

#define DDR_TEST_DEPTH (1<<29)
#define CDMA_TEST_DEPTH 16384
#define CDMA_TEST_DDRSRC_BASEADDR 0x0
#define CDMA_TEST_DDRDST_BASEADDR 0x10000000

#define SEQUENCE_LEN 192
#define HIDDEN_DIM 896
#define VOCAB_SIZE 151936
#define BYPASS_BASE 0x200000
#define IP_BASEADDR 0xa1000000
#define KVCACHE_BASE 0xa0800000

#define LINE_BUF_SIZE 1024

#define FUNCTION_DEBUG_PRINT

XAxiCdma_Config *cdmaConfig;
XAxiCdma cdma;  
volatile u32* regBase;
volatile u32* cdmaBase;

typedef struct {
    int index;
    int num;
} my_metadata_item;

u32 mapInit(){
    int mapped=open("/dev/mem", O_RDWR|O_SYNC);
    if(mapped==-1){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Open device failed!\n");
        #endif
        return XST_FAILURE;
    }
    regBase=(u32*)mmap(NULL, MAP_REG_DEPTH, PROT_READ|PROT_WRITE, MAP_SHARED, mapped, MAP_REG_BASEADDR);
    if(regBase==MAP_FAILED){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Mapping failed!\n");
        #endif
        close(mapped);
        return XST_FAILURE;
    }
    cdmaBase=(u32*)mmap(NULL, MAP_CDMA_DEPTH, PROT_READ|PROT_WRITE, MAP_SHARED, mapped, MAP_CDMA_BASEADDR);
    if(cdmaBase==MAP_FAILED){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Mapping failed!\n");
        #endif
        close(mapped);
        return XST_FAILURE;
    }
}

u32 ddrGetPhysAddr(){
    FILE *fp=fopen("workspace/pynq_alloc_phys_addr.txt", "r");
    if(fp==NULL){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Open pynq allocated address file failed!\n");
        #endif
        return 0;
    }
    char addr[20];
    fgets(addr, 20, fp);
    printf("buffer addr=%s\n",addr);
    fclose(fp);
    return (u32)atoi(addr);
}

u32 embeddingGetPhysAddr(){
    FILE *fp=fopen("workspace/embedding_address.txt", "r");
    if(fp==NULL){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Open embedding address file failed!\n");
        #endif
        return 0;
    }
    char addr[20];
    fgets(addr, 20, fp);
    printf("buffer addr=%s\n",addr);
    fclose(fp);
    return (u32)atoi(addr);
}

u32 resultGetPhysAddr(){
    FILE *fp=fopen("workspace/result_address.txt", "r");
    if(fp==NULL){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Open result address file failed!\n");
        #endif
        return 0;
    }
    char addr[20];
    fgets(addr, 20, fp);
    printf("result addr=%s\n",addr);
    fclose(fp);
    return (u32)atoi(addr);
}



u32 getSeqValidLen(){
    FILE *fp=fopen("workspace/seq_valid_len.txt", "r");
    if(fp==NULL){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Open sequence valid length file failed!\n");
        #endif
        return 0;
    }
    char addr[20];
    fgets(addr, 20, fp);
    // printf("sequence length=%s\n",addr);
    fclose(fp);
    return (u32)atoi(addr);
}



void regWrite32(u32 index, u32 value){
    regBase[index]=value;
};

u32 regRead32(u32 index){
    return regBase[index];
}

void cdmaCfgWrite32(u32 index, u32 value){
    cdmaBase[index]=value;
};

u32 cdmaCfgRead32(u32 index){
    return cdmaBase[index];
}


void cdmaCfgReset(XAxiCdma *InstancePtr){
	cdmaCfgWrite32(XAXICDMA_CR_OFFSET>>2, XAXICDMA_CR_RESET_MASK);
	InstancePtr->SimpleNotDone=0;
	InstancePtr->SGWaiting=0;
	InstancePtr->SgHandlerHead=0;
	InstancePtr->SgHandlerTail=0;
	InstancePtr->SimpleCallBackFn=NULL;
	InstancePtr->SimpleCallBackRef=NULL;
    printf("cr=%x, %x\n", cdmaCfgRead32(XAXICDMA_CR_OFFSET>>32), XAXICDMA_CR_OFFSET>>32);
	return;
}

int cdmaCfgIsResetDone(){
	return cdmaCfgRead32(XAXICDMA_CR_OFFSET>>2)&XAXICDMA_CR_RESET_MASK ? 0 : 1;
}

int cdmaCfgIsSimpleMode(){
	return cdmaCfgRead32(XAXICDMA_CR_OFFSET>>2)&XAXICDMA_CR_SGMODE_MASK ? 0 : 1;
}

int cdmaCfgIsBusy(){
	return cdmaCfgRead32(XAXICDMA_SR_OFFSET>>2)&XAXICDMA_SR_IDLE_MASK ? 0 : 1;
}

u32 cdmaCfgIntrEnabled(){
	return cdmaCfgRead32(XAXICDMA_CR_OFFSET>>2)&XAXICDMA_XR_IRQ_ALL_MASK;
}

u32 cdmaCfgInit(
    XAxiCdma *InstancePtr, 
    XAxiCdma_Config *CfgPtr,
	UINTPTR EffectiveAddr
){
	u32 RegValue;
	int TimeOut;

	InstancePtr->Initialized=0;
	InstancePtr->BaseAddr=EffectiveAddr;
	InstancePtr->HasDRE=CfgPtr->HasDRE;
	InstancePtr->IsLite=CfgPtr->IsLite;
	InstancePtr->WordLength=((unsigned int)CfgPtr->DataWidth) >> 3;
	InstancePtr->AddrWidth=CfgPtr->AddrWidth;
    
	if(InstancePtr->WordLength<4){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Word length too short %d\n", InstancePtr->WordLength);
        #endif
        return XST_FAILURE;
    }
	RegValue=cdmaCfgRead32(XAXICDMA_SR_OFFSET>>2);
	InstancePtr->SimpleOnlyBuild=!(RegValue&XAXICDMA_SR_SGINCLD_MASK);

	if(InstancePtr->SimpleOnlyBuild&&CfgPtr->IsLite)
		InstancePtr->MaxTransLen=InstancePtr->WordLength*CfgPtr->BurstLen;
    else
		InstancePtr->MaxTransLen=XAXICDMA_MAX_TRANSFER_LEN;

	TimeOut=XAXICDMA_RESET_LOOP_LIMIT;
	cdmaCfgReset(InstancePtr);

	while(TimeOut){
		if(cdmaCfgIsResetDone())
			break;
		TimeOut-=1;
	}

	if(!TimeOut){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Reset failed\n");
        #endif
        return XST_FAILURE;
    }
	InstancePtr->AllBdCnt=0;
	InstancePtr->FreeBdCnt=0;
	InstancePtr->HwBdCnt=0;
	InstancePtr->PreBdCnt=0;
	InstancePtr->PostBdCnt=0;
	InstancePtr->Initialized=1;
    
    return XST_SUCCESS;
}

int cdmaCfgSetSimpleMode(XAxiCdma *InstancePtr){
    if(cdmaCfgIsSimpleMode(InstancePtr))
        return XST_SUCCESS;
    if(cdmaCfgIsBusy()){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("SwitchMode: engine is busy!\n");
        #endif
        return XST_DEVICE_BUSY;
    }
    cdmaCfgWrite32(XAXICDMA_CR_OFFSET>>2,
        (cdmaCfgRead32(XAXICDMA_CR_OFFSET>>2)&~XAXICDMA_CR_SGMODE_MASK));

    printf("cr=%x, %x\n", cdmaCfgRead32(XAXICDMA_CR_OFFSET>>32), XAXICDMA_CR_OFFSET>>32);

    if(cdmaCfgIsSimpleMode(InstancePtr))
        return XST_SUCCESS;
    else
        return XST_FAILURE;
    return XST_FAILURE;
}

u32 cdmaSimpleTransfer(
    XAxiCdma *InstancePtr, 
    UINTPTR SrcAddr, 
    UINTPTR DstAddr,
	u32 Length, 
    XAxiCdma_CallBackFn SimpleCallBack, 
    void *CallBackRef
){
	if((Length<1)||(Length>XAXICDMA_MAX_TRANSFER_LEN))
		return XST_FAILURE;
	u32 WordBits=(u32)(InstancePtr->WordLength-1);
	if((SrcAddr&WordBits)||(DstAddr&WordBits)){
		if(!InstancePtr->HasDRE){
            #ifdef FUNCTION_DEBUG_PRINT
                printf("Unaligned transfer without DRE %x/%x\n", (unsigned int)SrcAddr, (unsigned int)DstAddr);
            #endif
			return XST_FAILURE;
		}
	}
	if(cdmaCfgIsBusy()){
        #ifdef FUNCTION_DEBUG_PRINT
            xdbg_printf(XDBG_DEBUG_ERROR, "Engine is busy\r\n");
		#endif
        return XST_FAILURE;
	}
	if(InstancePtr->SimpleNotDone){
        #ifdef FUNCTION_DEBUG_PRINT
            printf("Simple ongoing.\n");
        #endif
		return XST_FAILURE;
	}
	if(!cdmaCfgIsSimpleMode()){
		if(cdmaCfgSetSimpleMode(InstancePtr)!=XST_SUCCESS) {
            #ifdef FUNCTION_DEBUG_PRINT
                xdbg_printf(XDBG_DEBUG_ERROR, "Cannot switch to simple mode\r\n");
            #endif
			return XST_FAILURE;
		}
	}
	if((SimpleCallBack!=NULL)||((cdmaCfgIntrEnabled(InstancePtr)& 
        XAXICDMA_XR_IRQ_SIMPLE_ALL_MASK)!=0x0)){
		InstancePtr->SimpleNotDone=1;
	}
	InstancePtr->SimpleCallBackFn=SimpleCallBack;
	InstancePtr->SimpleCallBackRef=CallBackRef;
    
	cdmaCfgWrite32(XAXICDMA_SRCADDR_OFFSET>>2, LOWER_32_BITS(SrcAddr));
	if(InstancePtr->AddrWidth>32)
		cdmaCfgWrite32(XAXICDMA_SRCADDR_MSB_OFFSET>>2, UPPER_32_BITS(SrcAddr));
	cdmaCfgWrite32(XAXICDMA_DSTADDR_OFFSET>>2, LOWER_32_BITS(DstAddr));
	if(InstancePtr->AddrWidth>32)
		cdmaCfgWrite32(XAXICDMA_DSTADDR_MSB_OFFSET>>2, UPPER_32_BITS(DstAddr));
	cdmaCfgWrite32(XAXICDMA_BTT_OFFSET>>2, Length);
    // printf("src=%x, %x\n", cdmaCfgRead32(XAXICDMA_SRCADDR_OFFSET>>2),XAXICDMA_SRCADDR_OFFSET>>2);
    // printf("src_msb=%x, %x\n", cdmaCfgRead32(XAXICDMA_SRCADDR_MSB_OFFSET>>2),XAXICDMA_SRCADDR_MSB_OFFSET>>2);
    // printf("dst=%x, %x\n", cdmaCfgRead32(XAXICDMA_DSTADDR_OFFSET>>2),XAXICDMA_DSTADDR_OFFSET>>2);
    // printf("dst_msb=%x, %x\n", cdmaCfgRead32(XAXICDMA_DSTADDR_MSB_OFFSET>>2),XAXICDMA_DSTADDR_MSB_OFFSET>>2);
    // printf("len=%x, %x\n", cdmaCfgRead32(XAXICDMA_BTT_OFFSET>>2),XAXICDMA_BTT_OFFSET>>2);
	return XST_SUCCESS;
}

void cdmaInit(){
    cdmaConfig=XAxiCdma_LookupConfig(0);
    if(cdmaConfig==NULL)
        printf("CDMA device configuration lookup failed!\n");
    if(cdmaCfgInit(&cdma, cdmaConfig, cdmaConfig->BaseAddress)!=XST_SUCCESS)
        printf("CDMA initialization failed!\n");
}

typedef struct {
    int index;
    int num;
} metadata_item;

int get_metadata_item_from_file(FILE *fp, const char *target_key, my_metadata_item *item) {
    char line[LINE_BUF_SIZE];
    int found = 0;
    while (fgets(line, sizeof(line), fp)) {
        // for every line --- key:index,num
        char key[128];
        int address, num_uint8;
        if (sscanf(line, "%127[^:]:%d,%d", key, &address, &num_uint8) == 3) {
            if (strcmp(key, target_key) == 0) {
                item->index = address;
                item->num = num_uint8;
                found = 1;
                break;
            }
        }
    }
    return found ? 0 : -1;
}


// Concat two 16-bit values into a 32-bit value
u32 concat(u32 a, u32 b){return ((a&0x0000ffff)<<16)+(b&0x0000ffff);};

// The task-id under processing now
u32 taskIssued(){return regRead32(10)&0x0000ffff;};
// The task-id newly-retired just now
u32 taskRetired(){return (regRead32(10)>>16)&0x0000ffff;};
// The address in IP newly-written by DDR just now
u32 ddrWrited(){return regRead32(11);};
// The address in IP newly-read by DDR just now
u32 ddrRead(){return regRead32(12);};

    
// NORM ONLY
void norm(
    u32 id,
    u32 seq_len,
    u32 norm_weight_base,
    u32 q_proj_act_scale_recip_base
){
    // [4:0] 00400380_01c00380_00040038_000e0040_00000000
    // [9:5] 00ee0061_70044000_60002100_30000000_30005000
    regWrite32(1, 0x000e0040);
    regWrite32(2, concat(seq_len>>3, 0x0038));
    regWrite32(3, 0x01c00380);
    regWrite32(4, 0x00400380);
    regWrite32(5, concat(0x3000, 0x5000));
    regWrite32(6, concat(0x3000, 0x2000));
    regWrite32(7, concat(0x6000, 0x2000));
    regWrite32(8, concat((q_proj_act_scale_recip_base+0x20000)>>4, (norm_weight_base+0x20000)>>4));
    regWrite32(9, concat(id, 0x0245));
}


// V PROJECTION
void v_proj(
    u32 id,
    u32 seq_len,
    u32 seq_total_len,
    u32 v_proj_weight_base, 
    u32 bmm2_value_base,
    u32 v_proj_act_scale_base,
    u32 v_proj_weight_scale_base,
    u32 bmm2_value_scale_recip_base
){
    // [4:0] 00000020_01c00380_00040008_00020040_00000000
    // [9:5] 00010081_00004190_60482180_5c000000_30005700
    regWrite32(1, 0x00020040);
    regWrite32(2, concat(seq_len>>3, 0x0008));
    regWrite32(3, 0x01c00380);
    regWrite32(4, concat(0x0000, seq_total_len));
    regWrite32(5, concat(0x3000, v_proj_weight_base>>8));
    regWrite32(6, concat(bmm2_value_base>>8, 0x0000));
    regWrite32(7, concat(v_proj_act_scale_base>>4, v_proj_weight_scale_base>>4));
    regWrite32(8, concat(0x0000, (bmm2_value_scale_recip_base+0x20000)>>4));
    regWrite32(9, concat(id, 0x0081));
}


// K PROJECTION
void k_proj(
    u32 id,
    u32 seq_len,
    u32 seq_total_len,
    u32 k_proj_weight_base,
    u32 bmm1_key_base,
    u32 k_proj_act_scale_base,
    u32 k_proj_weight_scale_base,
    u32 bmm1_key_scale_recip_base,
    u32 rope_base
){    
    // [4:0] 00400020_01c00380_00040008_00020040_00000000;
    // [9:5] 00020061_80404000_603c2170_58000000_30005620
    regWrite32(1, 0x00020040);
    regWrite32(2, concat(seq_len>>3, 0x0008));
    regWrite32(3, 0x01c00380);
    regWrite32(4, concat(0x0040, seq_total_len));
    regWrite32(5, concat(0x3000, k_proj_weight_base>>8));
    regWrite32(6, concat(bmm1_key_base>>8, 0x0000));
    regWrite32(7, concat(k_proj_act_scale_base>>4, k_proj_weight_scale_base>>4));
    regWrite32(8, concat((bmm1_key_scale_recip_base+0x20000)>>4, (rope_base+0x20000)>>4));
    regWrite32(9, concat(id, 0x0061));
}

// Q PROJECTION
void q_proj(
    u32 id,
    u32 seq_len,
    u32 q_proj_weight_base,
    u32 q_proj_act_scale_base,
    u32 q_proj_weight_scale_base,
    u32 bmm1_query_scale_recip_base,
    u32 rope_base
){
    // [4:0] 00400380_01c00380_00040038_000e0040_00000000
    // [9:5] 00ee0061_70044000_60002100_30000000_30005000
    regWrite32(1, 0x000e0040);
    regWrite32(2, concat(seq_len>>3, 0x0038));
    regWrite32(3, 0x01c00380);
    regWrite32(4, 0x00400380);
    regWrite32(5, concat(0x3000, q_proj_weight_base>>8));
    regWrite32(6, concat(0x3000, 0x0000));
    regWrite32(7, concat(q_proj_act_scale_base>>4, q_proj_weight_scale_base>>4));
    regWrite32(8, concat((bmm1_query_scale_recip_base+0x20000)>>4, (rope_base+0x20000)>>4));
    regWrite32(9, concat(id, 0x0063));
}

void attention(
    u32 id,
    u32 seq_len,
    u32 seq_valid_len,
    u32 seq_total_len,
    u32 bmm1_key_base,
    u32 bmm1_query_scale_base,
    u32 bmm1_key_scale_base,
    u32 bmm2_score_scale_recip_base,
    u32 bmm2_value_base,
    u32 bmm2_score_scale_base,
    u32 bmm2_value_scale_base,
    u32 o_proj_act_scale_recip_base
){
    regWrite32(0, concat(0x0000, seq_valid_len));
    for(u32 head_idx=0; head_idx<14; ++head_idx){
        // [4:0] 00000010_01c00040_00010002_000e0040_00000000
        // [9:5] 00040123_80540000_604c21a0_33000000_30005800
        regWrite32(1, 0x000e0040);
        regWrite32(2, concat(seq_len>>3, seq_total_len>>4));
        regWrite32(3, 0x01c00040);
        regWrite32(4, concat(0x0000, seq_total_len));
        regWrite32(5, concat(0x3000+0x2*head_idx, (bmm1_key_base+(0x40*seq_total_len*(head_idx/7)))>>8));
        regWrite32(6, 0x32a00000);
        regWrite32(7, concat((bmm1_query_scale_base+0x2*seq_total_len*head_idx)>>4, (bmm1_key_scale_base+0x2*seq_total_len*(head_idx/7))>>4));
        regWrite32(8, concat((bmm2_score_scale_recip_base+0x2*seq_total_len*head_idx+0x20000)>>4, 0x0000));
        regWrite32(9, concat(id+2*head_idx, 0x123));
        // [4:0] 00200380_00100020_00010004_000e0040_00000000
        // [9:5] 00050103_809c0000_608c21d8_30000000_33005c00
        regWrite32(1, 0x000e0040);
        regWrite32(2, concat(seq_len>>3, 0x0004));
        regWrite32(3, concat(seq_total_len>>1, seq_total_len));
        regWrite32(4, concat(seq_total_len, 0x0380));
        regWrite32(5, concat(0x32a0, (bmm2_value_base+(0x40*seq_total_len*(head_idx/7)))>>8));
        regWrite32(6, concat(0x3000+0x2*head_idx, 0x0000));
        regWrite32(7, concat((bmm2_score_scale_base+0x2*seq_total_len*head_idx)>>4, (bmm2_value_scale_base+0x80*(head_idx/7))>>4));
        regWrite32(8, concat((o_proj_act_scale_recip_base+0x20000)>>4, 0x0000));
        regWrite32(9, concat(id+2*head_idx+1, 0x103));
    }
}

// O PROJECTION
void o_proj(
    u32 id,
    u32 seq_len,
    u32 o_proj_weight_base,
    u32 o_proj_act_scale_base,
    u32 o_proj_weight_scale_base,
    u32 gate_proj_act_scale_recip_base,
    u32 mlp_norm_weight_base
){
    // [4:0] 00400380_01c00380_00040038_000e0040_00000000
    // [9:5] 00ee0061_70044000_60002100_30000000_30005000
    regWrite32(1, 0x000e0040);
    regWrite32(2, concat(seq_len>>3, 0x0038));
    regWrite32(3, 0x01c00380);
    regWrite32(4, 0x00400380);
    regWrite32(5, concat(0x3000, o_proj_weight_base>>8));
    regWrite32(6, concat(0x3000, 0x2000));
    regWrite32(7, concat(o_proj_act_scale_base>>4, o_proj_weight_scale_base>>4));
    regWrite32(8, concat((gate_proj_act_scale_recip_base+0x20000)>>4, (mlp_norm_weight_base+0x20000)>>4));
    regWrite32(9, concat(id, 0x0045));
}

void mlp0_17(
    u32 id,
    u32 seq_len,
    u32 gate_proj_weight_base,
    u32 gate_proj_act_scale_base,
    u32 gate_proj_weight_scale_base,
    u32 up_proj_weight_base,
    u32 up_proj_act_scale_base,
    u32 up_proj_weight_scale_base,
    u32 down_proj_act_scale_recip_base,
    u32 down_proj_weight_base,
    u32 down_proj_act_scale_base,
    u32 down_proj_weight_scale_base
){
    regWrite32(1, 0x000e0040);
    regWrite32(2, 0x00010010);
    regWrite32(3, 0x01c00380);
    regWrite32(4, 0x00000100);
    u32 seq_idx = 0;
    for(seq_idx=0; seq_idx<(seq_len>>3); ++seq_idx){
        // gate
        // [4:0] 00000000_01c00380_00010010_000e0040_00000000
        // [9:5] 00010011_00000000_60002220_00000000_30005000
        regWrite32(5, concat(0x3000+0x1c*seq_idx, gate_proj_weight_base>>8));
        regWrite32(6, 0x00000000);
        regWrite32(7, concat((gate_proj_act_scale_base+seq_idx*0x10)>>4, gate_proj_weight_scale_base>>4));
        regWrite32(8, 0x00000000);
        regWrite32(9, concat(id+2*seq_idx, 0x0011));
        // up
        // [4:0] 00000100_01c00380_00010010_000e0040_00000000
        // [9:5] 0002000b_80080000_60042480_33004a00_300051c0
        regWrite32(5, concat(0x3000+0x1c*seq_idx, up_proj_weight_base>>8));
        regWrite32(6, concat(0x32a0+0x8*seq_idx, 0x4a00));
        regWrite32(7, concat((up_proj_act_scale_base+seq_idx*0x10)>>4, up_proj_weight_scale_base>>4));
        regWrite32(8, concat((down_proj_act_scale_recip_base+seq_idx*0x10+0x20000)>>4, 0x0000));
        regWrite32(9, concat(id+2*seq_idx+1, 0x0009));

        if(seq_idx==(seq_len>>4)-1){
            u16 task=taskRetired();
            while(task!=id+2*seq_idx+1)
                task = taskRetired();
        }
    }
    // down
    // [4:0] 00000380_00800100_00010038_000e0040_00000000
    // [9:5] 00030005_80100000_600c24c0_00002000_33005380
    regWrite32(1, 0x000e0040);
    regWrite32(2, concat(seq_len>>3, 0x0038));
    regWrite32(3, 0x00800100);
    regWrite32(4, 0x00000380);
    regWrite32(5, concat(0x32a0, down_proj_weight_base>>8));
    regWrite32(6, 0x00002000);
    regWrite32(7, concat(down_proj_act_scale_base>>4, down_proj_weight_scale_base>>4));
    regWrite32(8, 0x00000000);
    regWrite32(9, concat(id+50, 0x0005));
}

void mlp18(
    u32 id,
    u32 seq_len,
    u32 gate_proj_weight_base,
    u32 gate_proj_act_scale_base,
    u32 gate_proj_weight_scale_base,
    u32 up_proj_weight_base,
    u32 up_proj_act_scale_base,
    u32 up_proj_weight_scale_base,
    u32 down_proj_act_scale_recip_base,
    u32 down_proj_weight_base,
    u32 down_proj_act_scale_base,
    u32 down_proj_weight_scale_base,
    u32 q_proj_act_scale_recip_base,
    u32 mlp_norm_weight_base
){
    regWrite32(1, 0x000e0040);
    regWrite32(2, 0x00010010);
    regWrite32(3, 0x01c00380);
    regWrite32(4, 0x00000100);
    u32 seq_idx=0;
    for(seq_idx=0; seq_idx<(seq_len>>3); ++seq_idx){
        // gate
        // [4:0] 00000000_01c00380_00010010_000e0040_00000000
        // [9:5] 00010011_00000000_60002220_00000000_30005000
        regWrite32(5, concat(0x3000+0x1c*seq_idx, gate_proj_weight_base>>8));
        regWrite32(6, 0x00000000);
        regWrite32(7, concat((gate_proj_act_scale_base+seq_idx*0x10)>>4, gate_proj_weight_scale_base>>4));
        regWrite32(8, 0x00000000);
        regWrite32(9, concat(id+2*seq_idx, 0x0011));
        // up
        // [4:0] 00000100_01c00380_00010010_000e0040_00000000
        // [9:5] 0002000b_80080000_60042480_33004a00_300051c0
        regWrite32(5, concat(0x3000+0x1c*seq_idx, up_proj_weight_base>>8));
        regWrite32(6, concat(0x32a0+0x8*seq_idx, 0x4a00));
        regWrite32(7, concat((up_proj_act_scale_base+seq_idx*0x10)>>4, up_proj_weight_scale_base>>4));
        regWrite32(8, concat((down_proj_act_scale_recip_base+seq_idx*0x10+0x20000)>>4, 0x0000));
        regWrite32(9, concat(id+2*seq_idx+1, 0x0009));

        if(seq_idx==(seq_len>>4)-1){
            u16 task=taskRetired();
            while(task!=id+2*seq_idx+1)
                task = taskRetired();
        }
    }
    // down
    // [4:0] 00000380_00800100_00010038_000e0040_00000000
    // [9:5] 00030045_80104530_600c24c0_30002000_330058c0
    regWrite32(1, 0x000e0040);
    regWrite32(2, concat(seq_len>>3, 0x0038));
    regWrite32(3, 0x00800100);
    regWrite32(4, 0x00000380);
    regWrite32(5, concat(0x32a0, down_proj_weight_base>>8));
    regWrite32(6, 0x30002000);
    regWrite32(7, concat(down_proj_act_scale_base>>4, down_proj_weight_scale_base>>4));
    regWrite32(8, concat((q_proj_act_scale_recip_base+0x20000)>>4, (mlp_norm_weight_base+0x20000)>>4));
    regWrite32(9, concat(id+50, 0x0045));
}


float concat_2uint8_to_float(uint8_t* base_address){
    uint16_t h = (uint16_t)base_address[0] | ((uint16_t)base_address[1] << 8); // to float16
    
    uint16_t h_exp = (h & 0x7C00) >> 10;  
    uint16_t h_sig = h & 0x03FF;          
    uint32_t f_sgn = (h & 0x8000) << 16;  

    uint32_t f_exp, f_sig;
    if (h_exp == 0) {
        if (h_sig == 0) {
            f_exp = 0;
            f_sig = 0;
        } else {
            while ((h_sig & 0x0400) == 0) {
                h_sig <<= 1;
                h_exp--;
            }
            h_sig &= 0x03FF;  
            f_exp = (uint32_t)(1 + (127 - 15)) << 23;
            f_sig = (uint32_t)h_sig << 13;
        }
    } else if (h_exp == 0x1F) {
        f_exp = 0xFF << 23;
        f_sig = (uint32_t)h_sig << 13;
    } else {
        f_exp = (uint32_t)(h_exp + (127 - 15)) << 23;
        f_sig = (uint32_t)h_sig << 13;
    }
    uint32_t f = f_sgn | f_exp | f_sig;
    float result;
    memcpy(&result, &f, sizeof(result));
    return result;
}

void matmul_fp16(float *result, const uint8_t * weight, const uint8_t *src, int t, int d, int n){
    // score(token,dim) * weight(dim,n=2) -> logits(token,n=2)
    for (int i = 0; i < t; i++) {
        for (int j = 0; j < n; j++) {
            float val = 0.0f;
            for (int k = 0; k < d; j++) {
                u32 index_offset_src = 2*(i*d+k);
                float src_value = concat_2uint8_to_float(src+index_offset_src);
                
                u32 index_offset_weight = 2*(k*n+j);
                float weight_value = concat_2uint8_to_float(src+index_offset_src);
                val += weight_value * src_value;
            }
        result[i*n+j] = val;
        }
    }
}
//matmul_fp16(result_PHY_address, score.index, BYPASS_BASE, VOCAB_SIZE, HIDDEN_DIM, 2);
    
    
    
int main(){

    clock_t start, end;
    //clock_t f_start, f_end;
    double time_used;
    //double f_used;
    u32 task;
    printf("\n--- Start Compilation --");
    
    // init everything in C 
    mapInit();
    printf("\nMAP init:\n");
    cdmaInit();
    printf("CDMA init\n");
    u32 ddr_PHY_src=ddrGetPhysAddr();
    printf("Get DDR address\n");
    u32 embedding_PHY_src=embeddingGetPhysAddr();
    printf("Get Embedding address\n");
    u32 result_PHY_address=resultGetPhysAddr();
    printf("Get Result address\n");
    
    start = clock();
    u32 counter=0;
    
    
    if(cdmaSimpleTransfer(&cdma, embedding_PHY_src, IP_BASEADDR+BYPASS_BASE, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)
        printf('Error: CDMA transfer failed!');
    while(cdmaCfgIsBusy());