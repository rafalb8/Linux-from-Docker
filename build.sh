#!/bin/bash

# Prepare dir
rm -rf out
mkdir -p out

# Build iso and save to ./out
DOCKER_BUILDKIT=1 docker build -t lfs -o ./out .
