#!/usr/bin/ash

run_latehook() {
    mkdir -p /run/rom /run/rootfs /run/upper /run/work

    # Move isofs
    mount -o move /new_root /run/rom

    # Mount rootfs
    mount -t squashfs /run/rom/rootfs.img /run/rootfs

    # Mount overlay
    mount -t overlay rootfs -o lowerdir=/run/rootfs,upperdir=/run/upper,workdir=/run/work /new_root

    # Mount modules
    mkdir -p /new_root/lib/modules
    mount /run/rom/modules.img /new_root/lib/modules
}