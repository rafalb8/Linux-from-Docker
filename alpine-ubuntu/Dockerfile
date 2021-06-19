# ----------------------------------------------------------
# Base image stage
# ----------------------------------------------------------

FROM alpine:edge as base

RUN apk --no-cache upgrade

# Add packages
RUN apk --no-cache add \
    bash \
    bash-completion \
    connman \
    dbus \
    eudev \
    htop \
    ncurses \
    openrc \
    parted \
    vim \
    nano

# Setup user
RUN echo "root:root" | chpasswd

# Set Bash as default
RUN sed -i 's/\/bin\/ash/\/bin\/bash/' /etc/passwd

# Services
RUN ln -s /etc/init.d/hwdrivers /etc/runlevels/sysinit/hwdrivers && \
    ln -s /etc/init.d/bootmisc /etc/runlevels/boot/bootmisc && \
    ln -s /etc/init.d/hostname /etc/runlevels/boot/hostname && \
    ln -s /etc/init.d/modules /etc/runlevels/boot/modules && \
    ln -s /etc/init.d/connman /etc/runlevels/boot/connman

# Modules
RUN >/etc/modules

# ----------------------------------------------------------
# Kernel stage
# ----------------------------------------------------------

FROM ubuntu:focal as kernel
RUN apt update && apt -y --no-install-recommends install linux-image-generic initramfs-tools
RUN mv /boot/initrd.img /boot/initrd

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:3.13 as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools

# Copy base image
COPY --from=base / /os

# Apply overlay
COPY overlay /os

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Copy kernel
COPY --from=kernel /boot /os/boot
COPY --from=kernel /lib/modules /os/lib/modules
# COPY --from=kernel /lib/firmware /os/lib/firmware

# Create ISO
RUN mkdir -p /out && grub-mkrescue /os -o /out/linux.iso -V LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out /
