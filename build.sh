#!/bin/bash

usage() {
    cat <<EOF
usage: $0 [image]
possible images : $images
EOF
    exit 1
}

# --- MAIN ---

# Find possible images
for image in build/*/Dockerfile.*; do
    images=$(echo -e "$images\n${image##*.}")
done

# Remove duplicates
images=$(echo "$images" | sort -u)

# Select kernel
KERNEL="$1"

# Check selected image
if [ $# = 0 ] || [ "$images" = "${images/$KERNEL/}" ]; then
    usage
fi

# Merge Dockerfile stages
for stage in build/*; do
    for file in $stage/{Dockerfile.$KERNEL,Dockerfile}; do
        if buf=$(cat $file 2>/dev/null) ; then
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
