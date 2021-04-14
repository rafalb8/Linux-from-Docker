# ----------------------------------------------------------
# Base image stage
# ----------------------------------------------------------

FROM alpine:edge as base

# Add packages
RUN apk --no-cache add \
    busybox-initscripts \
    bash \
    bash-completion \
    coreutils \
    findutils \
    connman \
    curl \
    dbus \
    dmidecode \
    htop \
    iproute2 \
    iptables \
    ncurses \
    ncurses-terminfo \
    openrc \
    openssh-server \
    parted \
    procps \
    qemu-guest-agent \
    rsync \
    strace \
    tar \
    tzdata \
    util-linux \
    vim \
    nano \
    xz

# Setup user
RUN echo "root:root" | chpasswd

# Set Bash as default
RUN sed -i 's/\/bin\/ash/\/bin\/bash/' /etc/passwd

# ----------------------------------------------------------
# Kernel stage
# ----------------------------------------------------------
FROM ubuntu:focal as kernel

RUN apt update && apt -y --no-install-recommends install linux-image-generic initramfs-tools

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:edge as builder

# Add packages
RUN apk --no-cache add parted grub grub-bios xorriso

# Copy base image
COPY --from=base / /os

# Copy kernel
COPY --from=kernel /boot /os/boot
# COPY --from=kernel /lib/firmware /os/lib/firmware
# COPY --from=kernel /lib/modules /os/lib/modules

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Create ISO
RUN mkdir -p /out && grub-mkrescue -o /out/linux.iso /os/. -- -volid RBOS -joliet on && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out/linux.iso /
