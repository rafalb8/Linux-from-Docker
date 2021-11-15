# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:3.14 as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools xz squashfs-tools

# Copy kernel and initrd
COPY --from=kernel /boot /os/boot
COPY --from=initrd /boot /os/boot

# Add modules
COPY --from=kernel /lib/modules /modules
RUN mksquashfs /modules /os/modules.img -comp xz

# Copy base image
COPY --from=base / /rootfs
RUN mksquashfs /rootfs /os/rootfs.img -comp xz

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Create ISO
RUN mkdir -p /out && grub-mkrescue /os --compress=xz -o /out/linux.iso -V LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out /