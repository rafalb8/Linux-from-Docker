# Linux from Docker
Build custom Linux iso with Docker

Inspired by: [docker-to-linux](https://github.com/iximiuz/docker-to-linux)

Possible images
* alpine-dCore  (Alpine rootfs with dCore-focal64 kernel)
* alpine-ubuntu (Alpine rootfs with ubuntu-focal kernel)
* alpine-arch   (Alpine rootfs with Arch Linux kernel)

# Building

Run
```bash
build.sh image-version
```

# Try it out in qemu
```bash
Run qemu with UEFI
./qemu.sh efi

Run qemu with BIOS
./qemu
```

