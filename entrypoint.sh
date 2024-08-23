#!/bin/bash

PATH="/usr/local/envs/nerf_loam/bin/:$PATH"

Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

exec "$@"
