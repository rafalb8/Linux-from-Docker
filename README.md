# Linux from Docker
Build custom Linux iso with Docker

Inspired by: [docker-to-linux](https://github.com/iximiuz/docker-to-linux)

Dockerfile builds Alpine Linux iso with dCore-focal64 kernel

# Building
Just run ```build.sh```

# Try it out in qemu
```bash
Run qemu with UEFI
./qemu.sh efi

Run qemu with BIOS
./qemu
```

