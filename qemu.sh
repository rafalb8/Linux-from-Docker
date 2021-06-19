#!/bin/bash

params='-enable-kvm -m 1G -vga std -cdrom out/linux.iso'
# params='-enable-kvm -m 1G -vga std -drive file=out/linux.iso,format=raw'

if [ "$1" == 'efi' ]; then
    params="$params -bios /usr/share/qemu/OVMF.fd" # Arch path -> /usr/share/edk2-ovmf/x64/OVMF.fd
fi

qemu-system-x86_64 $params
