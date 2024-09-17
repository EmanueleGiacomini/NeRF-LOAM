FROM nerf_loam_build_env

WORKDIR /nerf_loam
ADD third_party third_party

RUN pip3 install third_party/marching_cubes/dist/marching_cubes-0.0.0-cp38-cp38-linux_x86_64.whl
RUN pip3 install third_party/sparse_octree/dist/svo-0.0.0-cp38-cp38-linux_x86_64.whl
RUN pip3 install third_party/sparse_voxels/dist/grid-0.0.0-cp38-cp38-linux_x86_64.whl

RUN rm -rf /third_party
