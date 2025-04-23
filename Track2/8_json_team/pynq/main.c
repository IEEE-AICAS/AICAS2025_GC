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
    while(cdmaCfgIsBusy());	if(cdmaSimpleTransfer(&cdma, 1386857728, IP_BASEADDR+4325376, 24576, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1206954112, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214059520, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	LayerNorm(4587520,4374528);
	if(cdmaSimpleTransfer(&cdma, 1206954496, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207012096, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207011840, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207486720, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1207012864, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207070464, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207070208, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207498496, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1206550528, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1206953728, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1206951936, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207480576, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1207475200, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207485952, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207492864, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207487488, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207498240, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207474816, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1207071232, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207474432, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1207472640, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1209687936, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214061312, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1207498752, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1209688320, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1211877888, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1209687552, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1209677824, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214059136, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1211867392, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214056960, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214058752, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214466688, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221572096, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1207900160, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1210089728, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1212279296, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1208301568, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1210491136, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1212680704, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1208702976, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1210892544, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1213082112, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1209104384, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1211293952, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1213483520, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1209505792, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1211695360, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1213884928, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1214467072, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214524672, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214524416, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214999296, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1214525440, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214583040, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214582784, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1215011072, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1214063104, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214466304, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214464512, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214993152, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1214987776, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214998528, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1215005440, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1215000064, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1215010816, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214987392, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1214583808, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214987008, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1214985216, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1217200512, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221573888, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1215011328, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1217200896, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1219390464, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1217200128, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1217190400, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221571712, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1219379968, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221569536, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221571328, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221979264, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229084672, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1215412736, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1217602304, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1219791872, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1215814144, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1218003712, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1220193280, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1216215552, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1218405120, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1220594688, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1216616960, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1218806528, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1220996096, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1217018368, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1219207936, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221397504, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1221979648, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222037248, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222036992, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222511872, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1222038016, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222095616, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222095360, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222523648, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1221575680, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221978880, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1221977088, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222505728, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1222500352, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222511104, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222518016, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222512640, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222523392, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222499968, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1222096384, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222499584, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1222497792, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1224713088, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229086464, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1222523904, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1224713472, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1226903040, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1224712704, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1224702976, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229084288, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1226892544, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229082112, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229083904, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229491840, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236597248, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1222925312, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1225114880, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1227304448, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1223326720, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1225516288, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1227705856, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1223728128, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1225917696, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1228107264, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1224129536, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1226319104, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1228508672, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1224530944, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1226720512, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1228910080, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1229492224, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229549824, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229549568, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230024448, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1229550592, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229608192, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229607936, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230036224, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1229088256, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229491456, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1229489664, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230018304, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1230012928, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230023680, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230030592, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230025216, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230035968, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230012544, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1229608960, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230012160, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1230010368, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1232225664, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236599040, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1230036480, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1232226048, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1234415616, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1232225280, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1232215552, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236596864, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1234405120, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236594688, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236596480, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237004416, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244109824, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1230437888, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1232627456, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1234817024, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1230839296, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1233028864, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1235218432, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1231240704, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1233430272, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1235619840, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1231642112, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1233831680, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236021248, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1232043520, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1234233088, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1236422656, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1237004800, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237062400, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237062144, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237537024, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1237063168, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237120768, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237120512, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237548800, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1236600832, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237004032, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237002240, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237530880, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1237525504, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237536256, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237543168, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237537792, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237548544, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237525120, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1237121536, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237524736, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1237522944, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1239738240, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244111616, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1237549056, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1239738624, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1241928192, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1239737856, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1239728128, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244109440, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1241917696, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244107264, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244109056, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244516992, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251622400, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1237950464, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1240140032, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1242329600, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1238351872, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1240541440, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1242731008, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1238753280, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1240942848, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1243132416, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1239154688, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1241344256, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1243533824, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1239556096, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1241745664, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1243935232, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1244517376, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244574976, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244574720, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245049600, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1244575744, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244633344, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244633088, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245061376, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1244113408, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244516608, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1244514816, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245043456, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1245038080, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245048832, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245055744, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245050368, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245061120, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245037696, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1244634112, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245037312, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1245035520, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1247250816, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251624192, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1245061632, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1247251200, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1249440768, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1247250432, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1247240704, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251622016, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1249430272, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251619840, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251621632, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252029568, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259134976, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1245463040, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1247652608, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1249842176, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1245864448, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1248054016, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1250243584, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1246265856, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1248455424, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1250644992, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1246667264, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1248856832, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251046400, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1247068672, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1249258240, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1251447808, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1252029952, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252087552, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252087296, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252562176, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1252088320, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252145920, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252145664, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252573952, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1251625984, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252029184, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252027392, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252556032, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1252550656, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252561408, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252568320, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252562944, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252573696, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252550272, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1252146688, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252549888, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1252548096, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1254763392, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259136768, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1252574208, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1254763776, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1256953344, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1254763008, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1254753280, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259134592, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1256942848, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259132416, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259134208, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259542144, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266647552, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1252975616, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1255165184, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1257354752, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1253377024, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1255566592, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1257756160, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1253778432, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1255968000, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1258157568, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1254179840, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1256369408, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1258558976, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1254581248, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1256770816, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1258960384, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1259542528, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259600128, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259599872, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260074752, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1259600896, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259658496, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259658240, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260086528, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1259138560, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259541760, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1259539968, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260068608, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1260063232, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260073984, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260080896, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260075520, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260086272, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260062848, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1259659264, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260062464, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1260060672, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1262275968, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266649344, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1260086784, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1262276352, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1264465920, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1262275584, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1262265856, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266647168, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1264455424, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266644992, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266646784, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267054720, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274160128, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1260488192, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1262677760, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1264867328, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1260889600, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1263079168, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1265268736, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1261291008, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1263480576, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1265670144, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1261692416, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1263881984, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266071552, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1262093824, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1264283392, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1266472960, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1267055104, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267112704, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267112448, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267587328, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1267113472, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267171072, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267170816, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267599104, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1266651136, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267054336, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267052544, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267581184, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1267575808, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267586560, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267593472, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267588096, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267598848, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267575424, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1267171840, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267575040, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1267573248, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1269788544, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274161920, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1267599360, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1269788928, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1271978496, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1269788160, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1269778432, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274159744, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1271968000, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274157568, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274159360, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274567296, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281672704, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1268000768, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1270190336, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1272379904, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1268402176, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1270591744, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1272781312, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1268803584, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1270993152, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1273182720, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1269204992, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1271394560, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1273584128, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1269606400, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1271795968, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1273985536, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1274567680, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274625280, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274625024, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275099904, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1274626048, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274683648, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274683392, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275111680, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1274163712, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274566912, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1274565120, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275093760, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1275088384, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275099136, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275106048, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275100672, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275111424, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275088000, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1274684416, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275087616, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1275085824, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1277301120, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281674496, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1275111936, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1277301504, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1279491072, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1277300736, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1277291008, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281672320, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1279480576, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281670144, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281671936, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282079872, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289185280, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1275513344, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1277702912, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1279892480, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1275914752, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1278104320, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1280293888, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1276316160, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1278505728, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1280695296, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1276717568, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1278907136, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281096704, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1277118976, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1279308544, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1281498112, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1282080256, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282137856, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282137600, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282612480, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1282138624, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282196224, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282195968, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282624256, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1281676288, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282079488, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282077696, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282606336, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1282600960, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282611712, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282618624, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282613248, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282624000, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282600576, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1282196992, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282600192, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1282598400, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1284813696, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289187072, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1282624512, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1284814080, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1287003648, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1284813312, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1284803584, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289184896, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1286993152, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289182720, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289184512, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289592448, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296697856, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1283025920, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1285215488, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1287405056, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1283427328, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1285616896, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1287806464, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1283828736, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1286018304, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1288207872, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1284230144, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1286419712, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1288609280, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1284631552, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1286821120, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289010688, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1289592832, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289650432, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289650176, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290125056, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1289651200, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289708800, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289708544, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290136832, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1289188864, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289592064, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1289590272, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290118912, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1290113536, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290124288, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290131200, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290125824, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290136576, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290113152, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1289709568, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290112768, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1290110976, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1292326272, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296699648, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1290137088, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1292326656, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1294516224, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1292325888, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1292316160, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296697472, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1294505728, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296695296, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296697088, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297105024, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304210432, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1290538496, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1292728064, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1294917632, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1290939904, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1293129472, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1295319040, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1291341312, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1293530880, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1295720448, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1291742720, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1293932288, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296121856, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1292144128, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1294333696, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1296523264, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1297105408, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297163008, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297162752, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297637632, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1297163776, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297221376, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297221120, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297649408, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1296701440, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297104640, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297102848, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297631488, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1297626112, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297636864, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297643776, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297638400, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297649152, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297625728, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1297222144, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297625344, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1297623552, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1299838848, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304212224, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1297649664, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1299839232, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1302028800, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1299838464, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1299828736, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304210048, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1302018304, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304207872, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304209664, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304617600, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311723008, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1298051072, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1300240640, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1302430208, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1298452480, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1300642048, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1302831616, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1298853888, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1301043456, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1303233024, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1299255296, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1301444864, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1303634432, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1299656704, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1301846272, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304035840, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1304617984, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304675584, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304675328, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305150208, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1304676352, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304733952, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304733696, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305161984, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1304214016, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304617216, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1304615424, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305144064, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1305138688, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305149440, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305156352, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305150976, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305161728, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305138304, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1304734720, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305137920, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1305136128, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1307351424, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311724800, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1305162240, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1307351808, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1309541376, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1307351040, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1307341312, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311722624, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1309530880, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311720448, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311722240, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312130176, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319235584, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1305563648, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1307753216, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1309942784, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1305965056, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1308154624, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1310344192, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1306366464, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1308556032, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1310745600, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1306767872, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1308957440, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311147008, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1307169280, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1309358848, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1311548416, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1312130560, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312188160, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312187904, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312662784, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1312188928, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312246528, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312246272, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312674560, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1311726592, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312129792, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312128000, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312656640, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1312651264, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312662016, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312668928, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312663552, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312674304, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312650880, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1312247296, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312650496, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1312648704, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1314864000, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319237376, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1312674816, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1314864384, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1317053952, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1314863616, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1314853888, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319235200, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1317043456, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319233024, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319234816, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319642752, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326748160, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1313076224, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1315265792, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1317455360, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1313477632, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1315667200, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1317856768, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1313879040, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1316068608, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1318258176, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1314280448, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1316470016, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1318659584, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1314681856, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1316871424, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319060992, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1319643136, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319700736, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319700480, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320175360, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1319701504, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319759104, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319758848, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320187136, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1319239168, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319642368, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1319640576, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320169216, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1320163840, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320174592, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320181504, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320176128, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320186880, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320163456, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1319759872, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320163072, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1320161280, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1322376576, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326749952, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1320187392, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1322376960, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1324566528, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1322376192, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1322366464, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326747776, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1324556032, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326745600, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326747392, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327155328, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334260736, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1320588800, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1322778368, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1324967936, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1320990208, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1323179776, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1325369344, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1321391616, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1323581184, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1325770752, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1321793024, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1323982592, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326172160, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1322194432, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1324384000, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1326573568, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1327155712, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327213312, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327213056, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327687936, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1327214080, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327271680, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327271424, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327699712, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1326751744, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327154944, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327153152, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327681792, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1327676416, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327687168, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327694080, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327688704, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327699456, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327676032, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1327272448, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327675648, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1327673856, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1329889152, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334262528, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1327699968, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1329889536, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1332079104, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1329888768, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1329879040, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334260352, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1332068608, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334258176, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334259968, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334667904, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341773312, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1328101376, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1330290944, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1332480512, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1328502784, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1330692352, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1332881920, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1328904192, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1331093760, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1333283328, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1329305600, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1331495168, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1333684736, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1329707008, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1331896576, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334086144, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1334668288, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334725888, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334725632, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335200512, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1334726656, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334784256, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334784000, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335212288, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1334264320, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334667520, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1334665728, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335194368, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1335188992, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335199744, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335206656, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335201280, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335212032, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335188608, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1334785024, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335188224, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1335186432, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1337401728, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341775104, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1335212544, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1337402112, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1339591680, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1337401344, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1337391616, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341772928, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1339581184, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341770752, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341772544, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342180480, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349285888, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1335613952, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1337803520, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1339993088, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1336015360, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1338204928, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1340394496, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1336416768, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1338606336, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1340795904, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1336818176, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1339007744, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341197312, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1337219584, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1339409152, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1341598720, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1342180864, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342238464, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342238208, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342713088, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1342239232, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342296832, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342296576, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342724864, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1341776896, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342180096, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342178304, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342706944, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1342701568, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342712320, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342719232, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342713856, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342724608, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342701184, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1342297600, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342700800, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1342699008, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1344914304, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349287680, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1342725120, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1344914688, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1347104256, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1344913920, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1344904192, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349285504, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1347093760, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349283328, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349285120, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349693056, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356798464, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1343126528, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1345316096, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1347505664, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1343527936, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1345717504, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1347907072, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1343929344, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1346118912, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1348308480, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1344330752, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1346520320, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1348709888, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1344732160, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1346921728, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349111296, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1349693440, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349751040, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349750784, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350225664, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1349751808, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349809408, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349809152, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350237440, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1349289472, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349692672, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1349690880, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350219520, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1350214144, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350224896, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350231808, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350226432, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350237184, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350213760, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1349810176, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350213376, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1350211584, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1352426880, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356800256, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1350237696, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1352427264, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1354616832, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1352426496, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1352416768, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356798080, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1354606336, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356795904, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356797696, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357205632, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364311040, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1350639104, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1352828672, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1355018240, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1351040512, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1353230080, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1355419648, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1351441920, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1353631488, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1355821056, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1351843328, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1354032896, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356222464, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1352244736, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1354434304, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1356623872, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1357206016, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357263616, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357263360, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357738240, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1357264384, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357321984, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357321728, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357750016, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1356802048, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357205248, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357203456, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357732096, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1357726720, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357737472, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357744384, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357739008, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357749760, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357726336, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1357322752, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357725952, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1357724160, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1359939456, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364312832, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1357750272, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1359939840, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1362129408, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1359939072, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1359929344, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364310656, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1362118912, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364308480, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364310272, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364718208, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371823616, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1358151680, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1360341248, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1362530816, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1358553088, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1360742656, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1362932224, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1358954496, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1361144064, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1363333632, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1359355904, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1361545472, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1363735040, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1359757312, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1361946880, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364136448, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1364718592, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364776192, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364775936, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365250816, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1364776960, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364834560, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364834304, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365262592, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1364314624, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364717824, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1364716032, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365244672, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1365239296, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365250048, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365256960, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365251584, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365262336, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365238912, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1364835328, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365238528, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1365236736, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1367452032, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371825408, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1365262848, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1367452416, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1369641984, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1367451648, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1367441920, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371823232, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1369631488, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371821056, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371822848, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372230784, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379336192, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1365664256, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1367853824, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1370043392, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1366065664, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1368255232, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1370444800, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1366467072, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1368656640, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1370846208, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1366868480, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1369058048, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371247616, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1367269888, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1369459456, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1371649024, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1372231168, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372288768, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372288512, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372763392, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1372289536, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372347136, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372346880, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372775168, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1371827200, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372230400, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372228608, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372757248, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1372751872, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372762624, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372769536, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372764160, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372774912, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372751488, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1372347904, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372751104, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1372749312, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1374964608, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379337984, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1372775424, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1374964992, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1377154560, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1374964224, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1374954496, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379335808, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1377144064, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379333632, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379335424, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379743360, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386848768, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1373176832, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1375366400, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1377555968, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1373578240, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1375767808, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1377957376, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1373979648, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1376169216, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1378358784, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1374381056, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1376570624, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1378760192, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1374782464, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1376972032, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379161600, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, 1379743744, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379801344, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379801088, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380275968, IP_BASEADDR+4587904, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Kproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1379802112, IP_BASEADDR+5242880, 57344, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379859712, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379859456, IP_BASEADDR+4374528, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380287744, IP_BASEADDR+4374784, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Vproj(5242880,4587520,4374528,4374784);
	if(cdmaSimpleTransfer(&cdma, 1379339776, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379742976, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379741184, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380269824, IP_BASEADDR+4587904, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Qproj(5242880,4587520,4374528,4587904,4325376);
	if(cdmaSimpleTransfer(&cdma, 1380264448, IP_BASEADDR+4587520, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380275200, IP_BASEADDR+4374528, 768, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380282112, IP_BASEADDR+4592896, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380276736, IP_BASEADDR+4598272, 5376, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380287488, IP_BASEADDR+4375296, 256, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380264064, IP_BASEADDR+4603648, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Attention(4587520,4374528,4592896,4598272,4375296,4603648);
	if(cdmaSimpleTransfer(&cdma, 1379860480, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380263680, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1380261888, IP_BASEADDR+4374528, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1382477184, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386850560, IP_BASEADDR+4376320, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	Oproj(5242880,4587520,4374528,4587904,4376320);
	if(cdmaSimpleTransfer(&cdma, 1380288000, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1382477568, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1384667136, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1382476800, IP_BASEADDR+4587520, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1382467072, IP_BASEADDR+4374528, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386848384, IP_BASEADDR+4587904, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1384656640, IP_BASEADDR+4384256, 9728, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386846208, IP_BASEADDR+4393984, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386848000, IP_BASEADDR+4588288, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1379743360, IP_BASEADDR+4588672, 384, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386852352, IP_BASEADDR+4395776, 1792, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,0);
	if(cdmaSimpleTransfer(&cdma, 1380689408, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1382878976, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1385068544, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,1);
	if(cdmaSimpleTransfer(&cdma, 1381090816, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1383280384, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1385469952, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,2);
	if(cdmaSimpleTransfer(&cdma, 1381492224, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1383681792, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1385871360, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,3);
	if(cdmaSimpleTransfer(&cdma, 1381893632, IP_BASEADDR+5242880, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1384083200, IP_BASEADDR+5644288, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386272768, IP_BASEADDR+6045696, 401408, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN1_5(5242880,4587520,4374528,4587904,5644288,4384256,6045696,4588288,4393984,4);
	if(cdmaSimpleTransfer(&cdma, 1382295040, IP_BASEADDR+5242880, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1384484608, IP_BASEADDR+5414912, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	if(cdmaSimpleTransfer(&cdma, 1386674176, IP_BASEADDR+5586944, 172032, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	FFN6(5242880,4587520,4374528,4587904,5414912,4384256,5586944,4588288,4393984,4588672,4395776);
	if(cdmaSimpleTransfer(&cdma, IP_BASEADDR+BYPASS_BASE, result_PHY_address, 2* SEQUENCE_LEN * HIDDEN_DIM, NULL, NULL)!=XST_SUCCESS)
		printf('Error: CDMA transfer failed!');
	while(cdmaCfgIsBusy());
	return 0;
}