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
#define IP_BASEADDR 0xe0000000

#define LINE_BUF_SIZE 1024

#define FUNCTION_DEBUG_PRINT

u32 concat(u16 a, u16 b){return ((a<<16)&0xffff0000)+(b&0x0000ffff);};

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

u32 taskIssued(){return regRead32(10)&0x0000ffff;};
u32 taskRetired(){return (regRead32(10)>>16)&0x0000ffff;};
u32 ddrWrited(){return regRead32(11);};


void cdmaCfgReset(XAxiCdma *InstancePtr){
	cdmaCfgWrite32(XAXICDMA_CR_OFFSET>>2, XAXICDMA_CR_RESET_MASK);
	InstancePtr->SimpleNotDone=0;
	InstancePtr->SGWaiting=0;
	InstancePtr->SgHandlerHead=0;
	InstancePtr->SgHandlerTail=0;
	InstancePtr->SimpleCallBackFn=NULL;
	InstancePtr->SimpleCallBackRef=NULL;
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


void LayerNorm(
    u32 q_a_s_recip_addr,
    u32 n_w_addr
){
    // 320'h00ff0247_47004400_00000000_30002000_00000000_00000e00_00800040_0006001c_000e0040_00000000;
    regWrite32(1, 0x000e0040);
    regWrite32(2, 0x0006001c);
    regWrite32(3, 0x00800040);
    regWrite32(4, 0x00000e00);
    regWrite32(5, 0x00000000);
    regWrite32(6, 0x30002000);
    regWrite32(7, 0x00000000);
    regWrite32(8, concat(q_a_s_recip_addr>>4, n_w_addr>>4)); // q_proj.act_scale_reciprocal, input_layernorm.weight
    regWrite32(9, 0x00010247);
    while(taskIssued()!=0x0001) ;
}

void Kproj(
    u32 k_w_addr,
    u32 k_a_s_addr,
    u32 k_w_s_addr,
    u32 bmm1_k_a_s_recip_addr,
    u32 rope_addr
){
    // 320'h00ee0863_47004400_46004200_22a00000_30005000_01000000_07000380_00060004_000e0040_00000000;
    regWrite32(1, 0x00040040);
    regWrite32(2, 0x00060004);
    regWrite32(3, 0x07000380);
    regWrite32(4, 0x01000000);
    regWrite32(5, concat(0x3000, k_w_addr>>8)); //k_proj.weight
    regWrite32(6, 0x22a00000);
    regWrite32(7, concat(k_a_s_addr>>4, k_w_s_addr>>4)); // k_proj.act_scale, k_proj.weight_scale
    regWrite32(8, concat(bmm1_k_a_s_recip_addr>>4, rope_addr>>4)); // bmm1.key_scale_reciprocal, rope_suparam
    regWrite32(9, 0x00020863);
    while(taskIssued()!=0x0002);
}

void Vproj(
    u32 v_w_addr,
    u32 v_a_s_addr,
    u32 v_w_s_addr,
    u32 bmm2_v_a_s_recip
){
    // 320'h00dd0083_00004400_46004200_32a00000_30005000_00000000_07000380_00060004_000e0040_00000000;
    regWrite32(1, 0x00040040);
    regWrite32(2, 0x00060004);
    regWrite32(3, 0x07000380);
    regWrite32(4, 0x00000000);
    regWrite32(5, concat(0x3000, v_w_addr>>8)); //v_proj.weight
    regWrite32(6, 0x32a00000);
    regWrite32(7, concat(v_a_s_addr>>4, v_w_s_addr>>4)); // v_proj.act_scale, v_proj.weight_scale
    regWrite32(8, concat(0x0000, bmm2_v_a_s_recip>>4)); // bmm2.value_scale_reciprocal
    regWrite32(9, 0x00030083);
    while(taskIssued()!=0x0003);
}

void Qproj(
    u32 q_w_addr,
    u32 q_a_s_addr,
    u32 q_w_s_addr,
    u32 bmm1_q_a_s_recip_addr,
    u32 rope_addr
){
    // 320'h00cc0863_47004400_46004200_30000000_30005000_01000000_07000380_0006001c_000e0040_00000000;
    regWrite32(1, 0x000e0040);
    regWrite32(2, 0x0006001c);
    regWrite32(3, 0x07000380);
    regWrite32(4, 0x01000000);
    regWrite32(5, concat(0x3000, q_w_addr>>8)); // q_proj.weight
    regWrite32(6, 0x30000000);
    regWrite32(7, concat(q_a_s_addr>>4, q_w_s_addr>>4)); // q_proj.act_scale, q_proj.weight_scale
    regWrite32(8, concat(bmm1_q_a_s_recip_addr>>4, rope_addr>>4)); //  bmm1.query_scale_reciprocal, rope_suparam
    regWrite32(9, 0x00040863);
    while(taskIssued()!=0x0004);
}

void Attention(
    u32 bmm1_q_a_s_addr,
    u32 bmm1_k_a_s_addr,
    u32 bmm2_score_a_s_recip_addr,
    u32 bmm2_score_a_s_addr,
    u32 bmm2_v_a_s_addr,
    u32 o_a_s_recip_addr
){
    for(int i=0; i<84; i++){
        // 320'h00bb0123_47000000_46004200_40800000_300022a0_00000000_00800040_00010006_000e0040_00000000;
        regWrite32(2, 0x00010006);
        regWrite32(3, 0x00800040);
        regWrite32(4, 0x00000000);
        regWrite32(5, concat(0x3000+0x8*i, 0x22a0+0x30*((i/7)%2)));
        regWrite32(6, 0x40800000);
        regWrite32(7, concat((bmm1_q_a_s_addr>>4)+0x4*i, (bmm1_k_a_s_addr>>4)+0x18*((i/7)%0x2))); // bmm1.query_scale, bmm1.key_scale
        regWrite32(8, concat((bmm2_score_a_s_recip_addr>>4)+0x4*i, 0x0000)); // bmm2.score_scale
        regWrite32(9, concat(0x0800+i, 0x0123));


        // 320'h00aa0103_47000000_46004200_30000000_408032a0_00000000_018000c0_00010002_000e0040_00000000;
        regWrite32(2, 0x00010002);
        regWrite32(3, 0x018000c0);
        regWrite32(4, 0x00000000);
        regWrite32(5, concat(0x4080, 0x32a0+0x30*((i/7)%2)));
        regWrite32(6, concat(0x3000+0x8*i, 0x0000));
        regWrite32(7, concat((bmm2_score_a_s_addr>>4)+0x4*i, (bmm2_v_a_s_addr>>4)+0x8*((i/7)%0x2))); // bmm2.score_scale, bmm2.value_scale
        regWrite32(8, concat((o_a_s_recip_addr>>4)+0x4*i, 0x0000)); // o_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0900+i, 0x0103));
        
        if(i%14==13)
            while(taskIssued()!=0x0900+i);
    }
}

void Oproj(
    u32 o_w_addr,
    u32 o_a_s_addr,
    u32 o_w_s_addr,
    u32 g_a_s_recip_addr,
    u32 n_w_addr
){
    // 320'h00cc0047_47004400_46004200_30002000_30005000_01000e00_07000380_0006001c_000e0040_00000000;
    regWrite32(2, 0x0006001c);
    regWrite32(3, 0x07000380);
    regWrite32(4, 0x01000e00);
    regWrite32(5, concat(0x3000, o_w_addr>>8)); // o_proj.weight
    regWrite32(6, 0x30002000);
    regWrite32(7, concat(o_a_s_addr>>4, o_w_s_addr>>4)); // o_proj.act_scale, o_proj.weight_scale
    regWrite32(8, concat(g_a_s_recip_addr>>4, n_w_addr>>4)); // gate_proj.act_scale_reciprocal, post_attention_layernorm.weight
    regWrite32(9, 0x00050047);
    while(taskIssued()!=0x0005);
}

void FFN1_5(
    u32 g_w_addr,
    u32 g_a_s_addr,
    u32 g_w_s_addr,
    u32 d_a_s_recip_addr,
    u32 u_w_addr,
    u32 u_w_s_addr,
    u32 d_w_addr,
    u32 d_a_s_addr,
    u32 d_w_s_addr,
    u32 ffn_index
){
    for(int i=0; i<6; i++){
        // 320'h00ee0411_47000000_46004200_40000000_30005000_00000000_07000380_0001001c_000e0040_00000000
        regWrite32(2, 0x0001001c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000000);
        regWrite32(5, concat(0x3000+0x70*i, g_w_addr>>8)); // gate_proj.weight
        regWrite32(6, 0x40000000);
        regWrite32(7, concat((g_a_s_addr>>4)+0x4*i, (g_w_s_addr>>4)+0x70*ffn_index)); //gate_proj.act_scale, gate_proj.weight_scale
        regWrite32(8, concat((d_a_s_recip_addr>>4)+0x4*i, 0x0000)); //down_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0c00+i+ffn_index*6, 0x0411));

        // 320'h00dd000b_47000000_46004200_38004000_30005000_00000e00_07000380_0001001c_000e0040_00000000
        regWrite32(2, 0x0001001c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000e00);
        regWrite32(5, concat(0x3000+0x70*i, u_w_addr>>8)); //up_proj.weight
        regWrite32(6, 0x38004000);
        regWrite32(7, concat((g_a_s_addr>>4)+0x4*i, (u_w_s_addr>>4)+0x70*ffn_index)); //gate_proj.act_scale, up_proj.weight_scale
        regWrite32(8, concat((d_a_s_recip_addr>>4)+0x4*i, 0x0000)); //down_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0d00+i+ffn_index*6, 0x000b));

        // 320'h00cc0045_47004400_46004200_30002000_38005000_00000e00_07000380_0001001c_000e0040_00000000
        regWrite32(2, 0x0001001c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000e00);
        regWrite32(5, concat(0x3800, d_w_addr>>8)); //down_proj.weight
        regWrite32(6, 0x30002000);
        regWrite32(7, concat((d_a_s_addr>>4)+0x4*i, (d_w_s_addr>>4)+0x70*ffn_index)); //down_proj.act_scale, down_proj.weight_scale
        regWrite32(8, 0x00000000);
        regWrite32(9, concat(0x0e00+i+ffn_index*6, 0x0007));
        
    }
    while(taskIssued()!=0x0e00+5+ffn_index*6);
}

void FFN6(
    u32 g_w_addr,
    u32 g_a_s_addr,
    u32 g_w_s_addr,
    u32 d_a_s_recip_addr,
    u32 u_w_addr,
    u32 u_w_s_addr,
    u32 d_w_addr,
    u32 d_a_s_addr,
    u32 d_w_s_addr,
    u32 next_q_a_s_recip_addr,
    u32 next_n_w_addr
){
    for(int i=0; i<6; ++i){
        // 320'h00ee0411_47000000_46004200_40000000_30005000_00000000_07000380_0001000c_000e0040_00000000
        regWrite32(2, 0x0001000c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000000);
        regWrite32(5, concat(0x3000+0x70*i, g_w_addr>>8)); // gate_proj.weight
        regWrite32(6, 0x40000000);
        regWrite32(7, concat((g_a_s_addr>>4)+0x4*i, (g_w_s_addr>>4)+0x230)); //gate_proj.act_scale, gate_proj.weight_scale
        regWrite32(8, concat((d_a_s_recip_addr>>4)+0x4*i, 0x0000)); //down_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0c00+30+i, 0x0411));

        // 320'h00dd000b_47000000_46004200_38004000_30005000_00000e00_07000380_0001000c_000e0040_00000000
        regWrite32(2, 0x0001000c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000e00);
        regWrite32(5, concat(0x3000+0x70*i, u_w_addr>>8)); //up_proj.weight
        regWrite32(6, 0x38004000);
        regWrite32(7, concat((g_a_s_addr>>4)+0x4*i, (u_w_s_addr>>4)+0x230)); //gate_proj.act_scale, up_proj.weight_scale
        regWrite32(8, concat((d_a_s_recip_addr>>4)+0x4*i, 0x0000)); //down_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0d00+i+30, 0x000b));

        // 320'h00cc0047_47004400_46004200_30002000_38005000_00000e00_03000180_0001001c_000e0040_00000000
        regWrite32(2, 0x0001001c);
        regWrite32(3, 0x07000380);
        regWrite32(4, 0x00000e00);
        regWrite32(5, concat(0x3800, d_w_addr>>8)); //down_proj.weight
        regWrite32(6, 0x30002000);
        regWrite32(7, concat((d_a_s_addr>>4)+0x4*i, (d_w_s_addr>>4)+0x230)); //down_proj.act_scale, down_proj.weight_scales
        regWrite32(8, concat((next_q_a_s_recip_addr>>4)+0x4*i, next_n_w_addr>>4)); //up_proj.act_scale_reciprocal
        regWrite32(9, concat(0x0e00+i+30, 0x0047));
    }
    while(taskIssued()!=0x0e00+35);
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
    
    if(cdmaSimpleTransfer(&cdma, embedding_PHY_src, IP_BASEADDR+BYPASS_BASE, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)
        printf('Error: CDMA transfer failed!');
    while(cdmaCfgIsBusy());