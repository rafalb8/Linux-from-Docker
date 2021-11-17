# Linux from Docker
Build custom Linux iso with Docker

Inspired by: [docker-to-linux](https://github.com/iximiuz/docker-to-linux)

To build image select one of available kernels and filesystems

Available kernels
* arch   (Arch Linux)
* dCore  (Tiny Core Linux 'dCore-focal64')
* debian (Debian Unstable)
* ubuntu (Ubuntu 21.10 Impish Indri)

Available filesystems
* alpine (Alpine Linux)
* ubuntu (Ubuntu 21.10 Impish Indri)

# Building

To build image, run ./build.sh script with selected kernel and filesystem
```bash
./build.sh kernel filesystem
```
Example: Building image with debian kernel and ubuntu filesystem
```bash
./build.sh debian ubuntu
```

# Running built image in QEMU
```bash
Run QEMU with UEFI
./qemu.sh efi

Run QEMU with BIOS
./qemu
```
Default root password: toor

