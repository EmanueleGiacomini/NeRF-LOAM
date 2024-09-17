#!/bin/bash

# it should be run in docker container

cd /nerf_loam/third_party/marching_cubes && python setup.py bdist_wheel
cd /nerf_loam/third_party/sparse_octree && python setup.py bdist_wheel
cd /nerf_loam/third_party/sparse_voxels && python setup.py bdist_wheel