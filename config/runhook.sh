#!/usr/bin/ash

run_latehook() {
    mkdir -p /rom /rw /rootfs

    # Move iso to /rom
    mount -o move /new_root /rom

    # Mount tmpfs
    mount -t tmpfs -o size=90% tmpfs /rw
    mkdir -p /rw/upper /rw/work

    # Mount rootfs
    mount -t squashfs /rom/rootfs.img /rootfs

    # Mount overlay
    mount -t overlay overlay -o lowerdir=/rootfs,upperdir=/rw/upper,workdir=/rw/work /new_root

    # Mount modules
    mkdir -p /new_root/lib/modules
    mount /rom/modules.img /new_root/lib/modules

    umount /rootfs
}