#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>
#include <signal.h>
#include <sched.h>
#include <time.h>
#include <errno.h>
#include <sys/param.h>

#include "./driver/dma-proxy.h"
#include "dma_app.h"

#define TX_CHANNEL_COUNT 1
#define RX_CHANNEL_COUNT 1

const char *tx_channel_names[] = { "dma_proxy_tx", /* add unique channel names here */ };
const char *rx_channel_names[] = { "dma_proxy_rx", /* add unique channel names here */ };

/* Internal data which should work without tuning */
int m;

struct channel {
	struct channel_buffer *buf_ptr;
	int fd;
	pthread_t tid;
};

// static int test_size;

struct channel tx_channels[TX_CHANNEL_COUNT], rx_channels[RX_CHANNEL_COUNT];


/*******************************************************************************************************************/
/*
 * The following function is the transmit thread to allow the transmit and the receive channels to be
 * operating simultaneously. Some of the ioctl calls are blocking so that multiple threads are required.
 */
void tx_thread(struct channel *channel_ptr)
{
	int buffer_id = 0;
	int tx_counter = 0;
	//begin tx
	ioctl(channel_ptr->fd, START_XFER, &buffer_id);
	//wait tx
	while (1) {
		ioctl(channel_ptr->fd, FINISH_XFER, &buffer_id);
		if (channel_ptr->buf_ptr[buffer_id].status != PROXY_NO_ERROR)
			printf("Proxy tx transfer error\n");

		break;
	}
}

void rx_thread(struct channel *channel_ptr)
{
	int buffer_id = 0;
	int rx_counter = 0;
	//begin receive
	// channel_ptr->buf_ptr[buffer_id].length = output_size ;
	ioctl(channel_ptr->fd, START_XFER, &buffer_id);
	//wait receive
	while (1) {
		ioctl(channel_ptr->fd, FINISH_XFER, &buffer_id);
		if (channel_ptr->buf_ptr[buffer_id].status != PROXY_NO_ERROR) {
			printf("Proxy rx transfer error, # transfers 1, # completed %d, # in progress 0\n", rx_counter);
			exit(1);
		}
		break;
	}
}

/*******************************************************************************************************************/
/*
 * Setup the transmit and receive threads so that the transmit thread is low priority to help prevent it from
 * overrunning the receive since most testing is done without any backpressure to the transmit channel.
 */
void setup_threads()
{
	pthread_attr_t tattr_tx;
	int newprio = 20, i;
	struct sched_param param;

	/* The transmit thread should be lower priority than the receive
	 * Get the default attributes and scheduling param
	 */
	pthread_attr_init (&tattr_tx);
	pthread_attr_getschedparam (&tattr_tx, &param);

	/* Set the transmit priority to the lowest
	 */
	param.sched_priority = newprio;
	pthread_attr_setschedparam (&tattr_tx, &param);

	for (i = 0; i < RX_CHANNEL_COUNT; i++)
		pthread_create(&rx_channels[i].tid, NULL, rx_thread, (void *)&rx_channels[i]);

	for (i = 0; i < TX_CHANNEL_COUNT; i++)
		pthread_create(&tx_channels[i].tid, &tattr_tx, tx_thread, (void *)&tx_channels[i]);
}

/*******************************************************************************************************************/
/*
 * The main program starts the transmit thread and then does the receive processing to do a number of DMA transfers.
 */
void pspl_trans(int8_t* input_buffer, int32_t* output_buffer, int input_size, int output_size)
{
	int i;
	int buffer_id = 0;
	// printf("DMA proxy test\n");
	/* Open the file descriptors for each tx channel and map the kernel driver memory into user space */
	for (i = 0; i < TX_CHANNEL_COUNT; i++) {
		char channel_name[64] = "/dev/";
		strcat(channel_name, tx_channel_names[i]);
		tx_channels[i].fd = open(channel_name, O_RDWR);
		if (tx_channels[i].fd < 1) {
			printf("Unable to open DMA proxy device file: %s\r", channel_name);
			exit(EXIT_FAILURE);
		}
		tx_channels[i].buf_ptr = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer) * TX_BUFFER_COUNT,
										PROT_READ | PROT_WRITE, MAP_SHARED, tx_channels[i].fd, 0);
		if (tx_channels[i].buf_ptr == MAP_FAILED) {
			printf("Failed to mmap tx channel\n");
			exit(EXIT_FAILURE);
		}
	}

	/* Open the file descriptors for each rx channel and map the kernel driver memory into user space */
	for (i = 0; i < RX_CHANNEL_COUNT; i++) {
		char channel_name[64] = "/dev/";
		strcat(channel_name, rx_channel_names[i]);
		rx_channels[i].fd = open(channel_name, O_RDWR);
		if (rx_channels[i].fd < 1) {
			printf("Unable to open DMA proxy device file: %s\r", channel_name);
			exit(EXIT_FAILURE);
		}
		rx_channels[i].buf_ptr = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer) * RX_BUFFER_COUNT,
										PROT_READ | PROT_WRITE, MAP_SHARED, rx_channels[i].fd, 0);
		if (rx_channels[i].buf_ptr == MAP_FAILED) {
			printf("Failed to mmap rx channel\n");
			exit(EXIT_FAILURE);
		}
	}

	//begin tx
	tx_channels[0].buf_ptr[buffer_id].length = input_size;
	rx_channels[0].buf_ptr[buffer_id].length = output_size*4 ;
	//write data
	for (i = 0; i < input_size / sizeof(unsigned int) ; i++) // test_size / sizeof(unsigned int); i++)
		tx_channels[0].buf_ptr[buffer_id].buffer[i] = ((uint8_t)input_buffer[4*i+3] << 24) | ((uint8_t)input_buffer[4*i+2] << 16) | ((uint8_t)input_buffer[4*i+1] << 8) | (uint8_t)input_buffer[4*i];;
	/* Grab the start time to calculate performance then start the threads & transfers on all channels */
	setup_threads();

	/* Do the minimum to know the transfers are done before getting the time for performance */
	pthread_join(rx_channels[0].tid, NULL);
	
	// printf("******************************************************************");
	// printf("等待 0.1 秒...\n");
    usleep(100000);  // 等待 1 秒
    // printf("1 秒已过！\n");

	/* Grab the start time to calculate performance then start the threads & transfers on all channels */
	setup_threads();
	/* Do the minimum to know the transfers are done before getting the time for performance */
	pthread_join(rx_channels[0].tid, NULL);

	//read data
	for (i = 0; i < output_size; i++) {
		output_buffer[i] = rx_channels[0].buf_ptr[buffer_id].buffer[i];
	}


	/* Clean up all the channels before leaving */

	for (i = 0; i < TX_CHANNEL_COUNT; i++) {
		pthread_join(tx_channels[i].tid, NULL);
		munmap(tx_channels[i].buf_ptr, sizeof(struct channel_buffer));
		close(tx_channels[i].fd);
	}
	for (i = 0; i < RX_CHANNEL_COUNT; i++) {
		munmap(rx_channels[i].buf_ptr, sizeof(struct channel_buffer));
		close(rx_channels[i].fd);
	}

	// printf("DMA proxy test complete\n");
}

/*int main(int argc, char *argv[]){
	int input_size = 896 * 897;
	int output_size = 896 * 896 / 64 ;

	FILE *file = fopen("./data.txt", "r"); // 打开文件
    if (!file) {
        perror("无法打开文件");
        return EXIT_FAILURE;
    }

    int8_t buffer_0[input_size];
	int32_t buffer_1[output_size];
    size_t count = 0;
    int temp;

    while (fscanf(file, "%d", &temp) == 1 && count < input_size) {
        if (temp < INT8_MIN || temp > INT8_MAX) {
            fprintf(stderr, "数据超出 int8_t 范围: %d\n", temp);
            continue;
        }
        buffer_0[count++] = (int8_t)temp;
    }
	fclose(file);


	m = atoi(argv[1]);
	pspl_trans(buffer_0, buffer_1, input_size, output_size);
	// printf("******************************************************************");
	// printf("等待 0.1 秒...\n");
    // usleep(100000);  // 等待 1 秒
    // printf("1 秒已过！\n");
	// pspl_trans(buffer_0, buffer_1);

	int i;
	printf("the first 10 data is:");
	for (i = 0; i < 10; i++) { 
		 printf("%d",buffer_1[i]);
	 }
   printf("\n");
   printf("the last 10 data is:");
   for (i = output_size - 10; i < output_size ; i++) { 
	   printf("%d",buffer_1[i]);
   }
   printf("\n");
	return 0;
}*/