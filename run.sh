#!/bin/bash

export DATAROOT=~/projects/SLAM_datasets

seqs=( "09" "10" )
datasets=($(ls $DATAROOT))

export CUDA_VISIBLE_DEVICES="0"

for seq in ${seqs[@]}
do
    for dataset in ${datasets[@]}
    do
        if [ -d ./logs/$dataset ]; then
            continue
        fi
        export DATASET=$dataset
        export SEQUENCE=$seq
        docker_cmd="docker run --name nerf_loam_${dataset}_${seq} --rm -it \
                --shm-size=24576m --gpus all \
                -v ~/projects/SLAM_datasets:/data \
                -v ./:/nerf_loam \
                -e CUDA_VISIBLE_DEVICES=\"$CUDA_VISIBLE_DEVICES\" \
                -e DATAROOT=/data/ \
                -e DATASET=$dataset \
                -e SEQUENCE=\"$seq\" \
                nerf_loam_running_env \
                /bin/bash -c "
        py_cmd="\"python demo/run.py configs/kitti/kitti_${seq}.yaml\""
        cmd="$docker_cmd $py_cmd"
        echo $cmd
        eval $cmd 2>&1 | tee -a run09.log

        mv run09.log run09.$dataset.log

        echo "sleep 1 min for the well being of GPUs."
        sleep 1m
    done
done