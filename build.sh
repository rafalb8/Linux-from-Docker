#!/bin/bash

usage() {
    cat <<EOF
usage: $0 [kernel] [filesystem]
available kernels : $KERNELS

available filesystems : $FILESYSTEMS

EOF
    exit 1
}

# --- MAIN ---

# Find possible kernels
for image in build/01-kernel/Dockerfile.*; do
    KERNELS=$(echo -e "$KERNELS\n\t${image##*.}")
done

# Find possible filesystems
for image in build/03-filesystem/Dockerfile.*; do
    FILESYSTEMS=$(echo -e "$FILESYSTEMS\n\t${image##*.}")
done

# Select kernel and filesystem
for x in $KERNELS; do
    if [ "$1" == $x ]; then
        KERNEL=$x
    fi
done

for x in $FILESYSTEMS; do
    if [ "$2" == $x ]; then
        FILESYSTEM=$x
    fi
done

# Check selected image
if [ $# = 0 ] || [ "$KERNEL" == "" ] || [ "$FILESYSTEM" == "" ]; then
    usage
fi

# Merge Dockerfile stages
for stage in build/*; do
    # Kernel
    prefix=$KERNEL

    # Filesystem
    if echo $stage | grep 03-filesystem >/dev/null; then
        prefix=$FILESYSTEM
    fi

    # Read and merge
    for file in $stage/{Dockerfile.$prefix,Dockerfile}; do
        if buf=$(cat $file 2>/dev/null); then
            DOCKERFILE=$(echo -e "$DOCKERFILE\n$buf")
            break
        fi
    done
done

# echo "$DOCKERFILE"

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Build iso and save to ./out
echo "$DOCKERFILE" | docker build -t lfs -o ./out . -f -
