FROM nvidia/cuda:12.6.0-cudnn-devel-ubuntu20.04

ENV TZ=America/New_York

RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    git g++ build-essential libeigen3-dev cmake libgl1-mesa-glx xvfb wget bzip2 zip unzip

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -bfp /usr/local && rm -rf miniconda.sh \
    && conda update conda

RUN conda create --yes -n nerf_loam python=3.10 pytorch pytorch-cuda=12.4 -c pytorch -c nvidia

RUN git clone --depth 1 https://github.com/url-kaist/patchwork-plusplus.git && \
    cd patchwork-plusplus && conda run -n nerf_loam make pyinstall

COPY requirements.txt .

RUN conda run -n nerf_loam pip3 install -r requirements.txt

# WORKDIR /nerf_loam/third_party

# not work because no cuda during build
# RUN cd marching_cubes && conda run -n nerf_loam python setup.py install
# RUN cd sparse_octree && conda run -n nerf_loam python setup.py install
# RUN cd sparse_voxels && conda run -n nerf_loam python setup.py install

# we build in container first and copy them during build
ADD third_party third_party

RUN conda run -n nerf_loam pip3 install third_party/marching_cubes/dist/marching_cubes-0.0.0-cp310-cp310-linux_x86_64.whl
RUN conda run -n nerf_loam pip3 install third_party/sparse_octree/dist/svo-0.0.0-cp310-cp310-linux_x86_64.whl
RUN conda run -n nerf_loam pip3 install third_party/sparse_voxels/dist/grid-0.0.0-cp310-cp310-linux_x86_64.whl

RUN rm -rf patchwork-plusplus requirements.txt third_party
RUN conda clean --all --yes

WORKDIR /nerf_loam

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
