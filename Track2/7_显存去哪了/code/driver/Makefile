KERN_DIR := /lib/modules/$(shell uname -r)/build

obj-m := dma-proxy.o

all:
	make -C $(KERN_DIR) M=$(shell pwd) modules

clean:
	make -C $(KERN_DIR) M=$(shell pwd) clean
