FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV TZ=America/New_York

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    git g++ build-essential libeigen3-dev cmake libgl1-mesa-glx xvfb wget bzip2 zip unzip python3-pip python3-dev

RUN ln -s /usr/bin/python3 /usr/bin/python

# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
#     && bash miniconda.sh -bfp /usr/local && rm -rf miniconda.sh \
#     && conda update conda

# RUN conda create --yes -n nerf_loam python=3.8 pytorch pytorch-cuda=12.4 -c pytorch -c nvidia
RUN pip3 install torch==1.10.1+cu111 -f https://download.pytorch.org/whl/cu111/torch_stable.html

RUN git clone --depth 1 --branch v0.0.1 https://github.com/boyang9602/patchwork-plusplus.git && \
    cd patchwork-plusplus && make pyinstall

COPY requirements.txt .

RUN pip3 install -r requirements.txt

# WORKDIR /nerf_loam/third_party

# not work because no cuda during build
# RUN cd marching_cubes && python setup.py bdist_wheel
# RUN cd sparse_octree && python setup.py bdist_wheel
# RUN cd sparse_voxels && python setup.py bdist_wheel

# we build in container first and copy them during build
ADD third_party third_party

RUN pip3 install third_party/marching_cubes/dist/marching_cubes-0.0.0-cp38-cp38-linux_x86_64.whl
RUN pip3 install third_party/sparse_octree/dist/svo-0.0.0-cp38-cp38-linux_x86_64.whl
RUN pip3 install third_party/sparse_voxels/dist/grid-0.0.0-cp38-cp38-linux_x86_64.whl

RUN rm -rf patchwork-plusplus requirements.txt third_party

WORKDIR /nerf_loam

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
