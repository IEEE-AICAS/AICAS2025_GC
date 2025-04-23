# 检查并复制文件夹
QWEN_ACCEL_DIR="/lib/firmware/xilinx/qwen_accel"
if [ ! -d "$QWEN_ACCEL_DIR" ]; then
    echo "qwen_accel folder not found in /lib/firmware/xilinx/, copying..."
    cp -r ./qwen_accel /lib/firmware/xilinx/
else
    echo "qwen_accel folder already exists in /lib/firmware/xilinx/"
fi

xmutil unloadapp
xmutil loadapp qwen_accel

# 进入driver目录编译驱动
echo "Compiling DMA proxy driver..."
cd ./driver || { echo "Failed to enter driver directory!"; exit 1; }
make clean && make || { echo "Driver compilation failed!"; exit 1; }
cd .. || { echo "Failed to return to working directory!"; exit 1; }

# 加载流程
echo "Loading DMA proxy driver..."
insmod ./driver/dma-proxy.ko || { echo "Driver load failed!"; exit 1; }