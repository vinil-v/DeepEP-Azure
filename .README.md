# DeepEP-Azure-BuildSuite

This repository provides scripts to simplify the setup, build, and testing of [DeepEP](https://github.com/deepseek-ai/DeepEP) on Microsoft Azure ND96asr_H100_v5 VMSS instances. It includes steps to install dependencies, apply performance fixes, and run multi-node tests using NVSHMEM.

> ⚠️ **Disclaimer**: This is **not** an official Microsoft repository. The scripts here are provided as-is to facilitate faster testing and deployment. Microsoft does not maintain or provide support for DeepEP.

---

## ✅ Tested Environment

- **VM Type**: 2 × Standard ND96asr H100 v5
- **OS**: Ubuntu-HPC 22.04 - x64 Gen2  
  [Ubuntu-HPC Azure Marketplace Image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft-dsvm.ubuntu-hpc?tab=Overview)
- **Accelerated Networking**: **Disabled**  
  *(Accelerated networking must be disabled for DeepEP to function correctly.)*

---

## 📁 Repository Structure

```bash
DeepEP-Azure-buildsuite/
├── 01-DeepEP-Build.sh         # Installs dependencies, clones DeepEP, triggers reboot
├── 02-DeepEP_nvshmem.sh       # Installs NVSHMEM
├── 03-DeepEP_final.sh         # Applies fixes, builds DeepEP, prepares run script
├── README.md                  # This file
````

---

## 🚀 Quick Start

Run the following steps **on each VM** as the root user:

### 1. Clone the Repository

```bash
sudo -i
git clone https://github.com/vinil-v/DeepEP-Azure-buildsuite
cd DeepEP-Azure-buildsuite/
```

### 2. Install Dependencies & Reboot

```bash
sh 01-DeepEP-Build.sh
```

> ⚠️ This will automatically reboot the VM.

### 3. Install NVSHMEM (Post-Reboot)

```bash
sudo -i
cd DeepEP-Azure-buildsuite/
sh 02-DeepEP_nvshmem.sh
```

### 4. Build DeepEP and Apply Fixes

```bash
sh 03-DeepEP_final.sh
```

---

## 🔧 Configure and Run DeepEP

1. Switch to the DeepEP directory:

```bash
cd ~/DeepEP
```

2. Edit the `run.sh` script to reflect the **Master Node IP Address**:

```bash
vim run.sh
```

Example `run.sh`:

```bash
#!/bin/bash

MASTER_ADDR="10.233.X.X"   # IP of the master (rank 0) node
MASTER_PORT=4571           # Use a free port
WORLD_SIZE=2               # Total number of nodes
RANK=$1                    # This node's rank (0 or 1)
```

3. **Run the test:**

On the master node (RANK 0):

```bash
sh run.sh 0
```

On the secondary node (RANK 1):

```bash
sh run.sh 1
```

---

## 📊 Performance Gains

**Before Applying Fix:**

```bash
[tuning] Best dispatch (FP8): SMs 24, NVL chunk 28, RDMA chunk 32: 19.37 GB/s (RDMA), 63.23 GB/s (NVL)
[tuning] Best dispatch (BF16): SMs 24, NVL chunk 24, RDMA chunk 32: 21.81 GB/s (RDMA), 71.19 GB/s (NVL)
[tuning] Best combine: SMs 24, NVL chunk 4, RDMA chunk 32: 20.95 GB/s (RDMA), 68.38 GB/s (NVL)
```

**After Applying Fix:**

```bash
[tuning] Best dispatch (FP8): SMs 24, NVL chunk 28, RDMA chunk 16: 45.97 GB/s (RDMA), 150.04 GB/s (NVL)
[tuning] Best dispatch (BF16): SMs 24, NVL chunk 20, RDMA chunk 12: 60.33 GB/s (RDMA), 196.91 GB/s (NVL)
[tuning] Best combine: SMs 24, NVL chunk 4, RDMA chunk 24: 61.72 GB/s (RDMA), 201.46 GB/s (NVL)
```

## 📝 Notes

* These fixes bind each process rank to the correct CPU core, NUMA node, and GPU.
* A GitHub issue has been opened in the DeepEP repo suggesting the inclusion of these improvements.
* Microsoft is not responsible for DeepEP functionality. This repository is meant for **advisory** purposes only.
