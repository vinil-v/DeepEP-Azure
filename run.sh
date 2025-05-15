#!/bin/bash

# === CONFIGURATION ===
MASTER_ADDR="10.233.0.5"       # IP of the rank 0 node (can be IB IP)
MASTER_PORT=4571             # Use a free port
WORLD_SIZE=2                 # Number of nodes in total
RANK=$1                      # This node's rank (0 or 1)

# Interface name of IB (e.g., ib0 or mlx5_0 or eno5 for RoCE)

# Optional: enable debug logging
# export NCCL_DEBUG=INFO
# export PYTHONFAULTHANDLER=1

# Optional: force NCCL to use IB and skip other transport layers
export NCCL_NET_GDR_LEVEL=2             # Enable GPUDirect RDMA
export NCCL_IB_DISABLE=0

# Optional: reduce IB timeout issues
export NCCL_IB_TIMEOUT=22
export NCCL_IB_RETRY_CNT=10
export NCCL_IB_PCI_RELAXED_ORDERING=1
export LD_LIBRARY_PATH=/usr/local/nccl-rdma-sharp-plugins/lib:$LD_LIBRARY_PATH
export CUDA_DEVICE_ORDER=PCI_BUS_ID
export NCCL_SOCKET_IFNAME=eth0
#export NCCL_SOCKET_IFNAME=ib0
export NCCL_TOPO_FILE=/opt/microsoft/ndv5-topo.xml
export NCCL_DEBUG=WARN


export NVSHMEM_DIR=/opt/nvshmem/
export LD_LIBRARY_PATH="${NVSHMEM_DIR}/lib:$LD_LIBRARY_PATH":/usr/lib/x86_64-linux-gnu/libnccl.so
export PATH="${NVSHMEM_DIR}/bin:$PATH"

export PYTHONPATH=$PWD/build/lib.linux-x86_64-3.10:$PYTHONPATH
# === RUN ===
echo "Launching with RANK=$RANK, MASTER=$MASTER_ADDR:$MASTER_PORT, WORLD_SIZE=$WORLD_SIZE"
RANK=$RANK \
MASTER_ADDR=$MASTER_ADDR \
MASTER_PORT=$MASTER_PORT \
WORLD_SIZE=$WORLD_SIZE \
python3 tests/test_internode.py