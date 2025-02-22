#!/bin/bash

docker build --tag nerf_loam_build_env -f env.dockerfile .
docker run --rm -it --gpus all -v ./:/nerf_loam nerf_loam_build_env /bin/bash build_third_party.sh
docker build --tag nerf_loam_running_env -f nerf_loam.dockerfile .
