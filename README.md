# Linux from Docker
Build custom Linux iso with Docker

Inspired by: [docker-to-linux](https://github.com/iximiuz/docker-to-linux)

All images are built with Alpine rootfs 

Possible kernels
* arch   (Arch Linux kernel)
* dCore  (dCore-focal64 kernel)
* debian (Debian kernel)
* ubuntu (ubuntu-impish kernel)

# Building

Run
```bash
build.sh kernel
```

# Try it out in qemu
```bash
Run qemu with UEFI
./qemu.sh efi

Run qemu with BIOS
./qemu
```

