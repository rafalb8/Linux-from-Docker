#!/bin/bash

params='-enable-kvm -m 1G -vga std -cdrom out/linux.iso'
# params='-enable-kvm -m 1G -vga std -drive file=out/linux.iso,format=raw'

if [ "$1" == 'efi' ]; then
    # Possible paths
    # Ubuntu    /usr/share/qemu/OVMF.fd             Install ovmf
    # Arch      /usr/share/edk2-ovmf/x64/OVMF.fd    Install edk2-ovmf
    
    # Try to use x64 bit version
    efi=($(find /usr/share 2>/dev/null | grep 'OVMF.fd' | grep x64))
    efi=${efi[0]}

    # If not found, select first found
    if [ $efi == "" ]; then 
        efi=($(find /usr/share 2>/dev/null | grep 'OVMF.fd'))
        efi=${efi[0]}
    fi
    
    echo "Selecting $efi"
    params="$params -bios $efi"
fi

qemu-system-x86_64 $params
