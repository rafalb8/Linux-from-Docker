#!/usr/bin/ash

run_latehook() {
    echo 'Moving system to ram'
    mkdir -p /rom /rootfs

    # Move iso to /rom
    mount -o move /new_root /rom

    # Mount tmpfs @ /new_root
    mount -t tmpfs -o size=90% tmpfs /new_root

    # Mount rootfs squash
    mount -t squashfs /rom/rootfs.img /rootfs

    # Copying rootfs
    cp -rf /rootfs/* /new_root/.

    # Mount modules
    mkdir -p /new_root/lib/modules
    mount /rom/modules.img /new_root/lib/modules

    umount /rootfs
}