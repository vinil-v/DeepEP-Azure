#!/bin/sh
pip3 install torch torchvision torchaudio
lsmod | grep nvidia
gdrcopy_copybw
cd ~/
git clone https://github.com/deepseek-ai/DeepEP.git
wget https://developer.nvidia.com/downloads/assets/secure/nvshmem/nvshmem_src_3.2.5-1.txz
tar -xvf nvshmem_src_3.2.5-1.txz
cd nvshmem_src/
git apply ~/DeepEP/third-party/nvshmem.patch
echo 'options nvidia NVreg_EnableStreamMemOPs=1 NVreg_RegistryDwords="PeerMappingOverride=1;"' > /etc/modprobe.d/nvidia.conf
sudo update-initramfs -u
sudo reboot