# ----------------------------------------------------------
# Base image stage
# ----------------------------------------------------------

FROM alpine:edge as base

RUN apk --no-cache upgrade

# Add packages
RUN apk --no-cache add connman dbus eudev htop ncurses openrc vim nano

# Setup user
RUN echo "root:root" | chpasswd

# Services
RUN ln -s /etc/init.d/hwdrivers /etc/runlevels/sysinit/hwdrivers && \
    ln -s /etc/init.d/bootmisc /etc/runlevels/boot/bootmisc && \
    ln -s /etc/init.d/hostname /etc/runlevels/boot/hostname && \
    ln -s /etc/init.d/modules /etc/runlevels/boot/modules && \
    ln -s /etc/init.d/connman /etc/runlevels/boot/connman

# Modules
RUN >/etc/modules

# Apply overlay
COPY overlay /

# ----------------------------------------------------------
# Kernel stage
# ----------------------------------------------------------

FROM archlinux:base as kernel
RUN pacman -Sy --noconfirm linux

# Remove old initramfs
RUN rm /boot/*.img

# Configure mkinitcpio.conf
COPY alpine-arch/mkinitcpio.conf /etc/mkinitcpio.conf

# Add Build hook
COPY alpine-arch/buildhook.sh /etc/initcpio/install/rootfs

# Add Runtime hook
COPY alpine-arch/runhook.sh /etc/initcpio/hooks/rootfs

# Rename files
RUN for f in /boot/*; do mv $f $(echo $f | awk -F- '{print $1}'); done

# Build initramfs
RUN mkinitcpio --generate /boot/initrd --kernel $(ls /lib/modules)

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:3.13 as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools xz squashfs-tools

# Copy kernel and initrd
COPY --from=kernel /boot /os/boot

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
