# Drivers for Xilinx Versal FPGA IPs
import mmap
import struct
import numpy
import os
import time
import numpy as np
import threading
from time import sleep

class AXI_MEM:
    def __init__(self, base_addr, dtype: np.dtype, length=None, bytes=None):
        # 3 cases:
        # 1. length is None, bytes is None -> length = 1
        # 2. length is None: length = bytes / np.dtype(dtype).itemsize
        # 3. bytes is None: length is length

        if length is None and bytes is None:
            length = 1
        elif length is None and bytes is not None:
            length = bytes // np.dtype(dtype).itemsize
        elif length is not None and bytes is None:
            pass
        else:
            raise ValueError("Invalid parameters")

        self.base_addr = base_addr
        self.dtype = dtype
        self.length = length
        self.size = np.dtype(dtype).itemsize * length

        # align the base address to the page size
        self.page_offset = base_addr % mmap.PAGESIZE

        # Opening /dev/mem with read and write access
        self.fd = os.open("/dev/mem", os.O_RDWR | os.O_SYNC)

        # Mapping memory with aligned address and size
        self.mem = mmap.mmap(self.fd, self.size + self.page_offset, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=base_addr - self.page_offset)

        # Adjusting the numpy buffer to point to the correct location
        self.buffer = np.frombuffer(self.mem, dtype=dtype, count=length, offset=self.page_offset)

    def read(self, index=0):
        # Read a value from the memory
        return self.buffer[index]

    def write(self, value, index=0):
        # Write a value to the memory
        self.buffer[index] = value

    def __del__(self):
        # Clean up
        self.mem.close()
        os.close(self.fd)
    
    def __getitem__(self, index):
        return self.read(index)

    def __setitem__(self, index, value):
        self.write(value, index)


AXI_REGISTER = AXI_MEM


def AXI_IP(base_addr, reg_list):
    class _AXI_IP:
        def __init__(self, _base_addr, _reg_list):
            self.registers = {}
            for name, offset, dtype in _reg_list:
                abs_addr = _base_addr + offset
                reg = AXI_REGISTER(abs_addr, dtype)
                self.registers[name] = reg
                self._create_property(name)

        def _create_property(self, name):
            def getter(self):
                return self.registers[name].read()
            def setter(self, value):
                # print(f"Setting registr {name:20s} to 0x{value:016x}")
                self.registers[name].write(value)
            # Create the property and attach it to the instance
            setattr(self.__class__, name, property(getter, setter))
        
    return _AXI_IP(base_addr, reg_list)