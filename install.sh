#!/bin/bash

cd third_party/marching_cubes
python setup.py bdist_wheel
pip install dist/*.whl

cd ../sparse_octree
python setup.py bdist_wheel
pip install dist/*.whl

cd ../sparse_voxels
python setup.py bdist_wheel
pip install dist/*.whl