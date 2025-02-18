#!/bin/bash

export DATAROOT=./datasets

export CUDA_VISIBLE_DEVICES="0"

docker_cmd="docker run --name nerf_loam_vbr_pincio --rm -it \
    --shm-size=24576m --gpus all \
    -v ${DATAROOT}:/data \
    -v ./:/nerf_loam \
    -e CUDA_VISIBLE_DEVICES=\"$CUDA_VISIBLE_DEVICES\" \
    -e DATAROOT=/data/ \
    -e DATASET=vbr \
    -e SEQUENCE=pincio \
    nerf_loam_running_env \
    /bin/bash -c "
py_cmd = "\"python demo/run configs/vbr/vbr_pincio.yaml\""

cmd="$docker_cmd $py_cmd"
echo $cmd
eval $cmd 2>&1 | tee -a vbr_pincio.log

mv vbr_pincio.log vbr_pincio.log

echo "sleep 1 min for the well being of GPUs."
sleep 1m


