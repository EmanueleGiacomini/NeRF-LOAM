FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV TZ=America/New_York

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    git g++ libc++1 build-essential libeigen3-dev cmake  xvfb wget bzip2 zip unzip \
    python3-pip python3-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev libgl1-mesa-glx

RUN wget https://github.com/isl-org/Open3D/releases/download/v0.18.0/open3d-devel-linux-x86_64-cxx11-abi-0.18.0.tar.xz \
    && tar -xf open3d-devel-linux-x86_64-cxx11-abi-0.18.0.tar.xz \
    && rm open3d-devel-linux-x86_64-cxx11-abi-0.18.0.tar.xz \
    && cp -r open3d-devel-linux-x86_64-cxx11-abi-0.18.0/* /usr/local/

RUN ldconfig

RUN pip install --upgrade pip
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install torch==1.10.1+cu111 -f https://download.pytorch.org/whl/cu111/torch_stable.html

COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN git clone --depth 1 --branch 0.0.1 https://github.com/boyang9602/patchwork-plusplus.git && \
    cd patchwork-plusplus && mkdir build && cd build && cmake .. && make

RUN rm -rf requirements.txt third_party open3d-devel-linux-x86_64-cxx11-abi-0.18.0

WORKDIR /nerf_loam
