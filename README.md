# Linux from Docker
Build custom Linux iso with Docker

Inspired by: [docker-to-linux](https://github.com/iximiuz/docker-to-linux)

To build image select one of available kernels and filesystems

Available kernels
* arch   (Arch Linux kernel)
* dCore  (dCore-focal64 kernel)
* debian (Debian kernel)
* ubuntu (ubuntu-impish kernel)

Available filesystems
* alpine
* ubuntu

# Building

To build image, run ./build.sh script with selected kernel and filesystem
```bash
./build.sh kernel filesystem
```
Example: Building image with debian kernel and ubuntu filesystem
```bash
./build.sh debian ubuntu
```

# Try build image in QEMU
```bash
Run QEMU with UEFI
./qemu.sh efi

Run QEMU with BIOS
./qemu
```
Default root password: toor

