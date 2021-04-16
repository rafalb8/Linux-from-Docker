#!/bin/bash

getImages() {
    cfgDirs="config out overlay"
    dirs=$(ls -xd */ | sed -e 's/\///g')
    images=""
    for dir in $dirs; do
        if [ "$cfgDirs" = "${cfgDirs/$dir/}" ]; then
            images="$images $dir"
        fi
    done
}

usage() {
    cat <<EOF
usage: $0 image
possible images : $images
EOF

    exit 1
}

# Get possible images list
getImages

# Prepare dir
rm -rf outecho
mkdir -p out

selected="$1"
if [ $# = 0 ] || [ "$images" = "${images/$selected/}" ]; then
    usage
fi

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Build iso and save to ./out
docker build -t lfs -o ./out -f $selected/Dockerfile .
