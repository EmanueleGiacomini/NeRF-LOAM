#!/bin/bash

# export DATAROOT=./datasets
export DATAROOT=/media/rvp-00/DATA1/datasets
export CUDA_VISIBLE_DEVICES="0"

experiments=("maicity_00" "kitti_09" "campus" "pincio" "quad_easy")

for exp in ${experiments}
do
    if [ -d ./logs/$exp ]; then
        continue
    fi
    docker_cmd="docker run --name nerf_loam_${exp} --rm -it \
        --shm-size=24576m --gpus all \
        -v ${DATAROOT}:/data \
        -v ./:/nerf_loam \
        -e CUDA_VISIBLE_DEVICES=\"$CUDA_VISIBLE_DEVICES\" \
        -e DATAROOT=/data/ \
        -e DATASET=$exp \
        nerf_loam_running_env \
        /bin/bash -c "
    py_cmd="\"python demo/run.py configs_eg/${exp}.yaml\""
    cmd="$docker_cmd $py_cmd"
    echo $cmd
    eval $cmd 2>&1 | tee -a ${exp}.log

    echo "sleep 1 min for the well being of GPUs."
    sleep 1m
done