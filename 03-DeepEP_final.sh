#!/bin/bash
export NVSHMEM_DIR=/opt/nvshmem/
export LD_LIBRARY_PATH="${NVSHMEM_DIR}/lib:$LD_LIBRARY_PATH"
export PATH="${NVSHMEM_DIR}/bin:$PATH"
apt-get update
apt-get install ninja-build
cd ~/DeepEP
NVSHMEM_DIR=/opt/nvshmem python3 setup.py build
ln -s build/lib.linux-x86_64-3.10/deep_ep_cpp.cpython-310-x86_64-linux-gnu.so deep_ep_cpp.cpython-310-x86_64-linux-gnu.so
export PYTHONPATH=$PWD/build/lib.linux-x86_64-3.10:$PYTHONPATH
python3 -c "import deep_ep"
python3 tests/test_intranode.py
echo "Applying patch to DeepEP"
cp ~/DeepEP-Azure-buildsuite/run.sh ~/DeepEP
cp ~/DeepEP-Azure-buildsuite/diff_deepep ~/DeepEP
git apply diff_deepep
rm deep_ep_cpp.cpython-310-x86_64-linux-gnu.so
export NVSHMEM_DIR=/opt/nvshmem/
export LD_LIBRARY_PATH="${NVSHMEM_DIR}/lib:$LD_LIBRARY_PATH"
export PATH="${NVSHMEM_DIR}/bin:$PATH"
NVSHMEM_DIR=/opt/nvshmem python3 setup.py build
ln -s build/lib.linux-x86_64-3.10/deep_ep_cpp.cpython-310-x86_64-linux-gnu.so deep_ep_cpp.cpython-310-x86_64-linux-gnu.so