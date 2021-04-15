# ----------------------------------------------------------
# Base image stage
# ----------------------------------------------------------

FROM alpine:edge as base

# Add packages
RUN apk --no-cache add \
    bash \
    bash-completion \
    coreutils \
    findutils \
    util-linux \
    connman \
    dbus \
    curl \
    dmidecode \
    htop \
    ncurses \
    openrc \
    openssh-server \
    openssh-client \
    parted \
    procps \
    vim \
    nano \
    qemu-guest-agent

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
RUN apk --no-cache add grub grub-bios xorriso mtools

# Copy base image
COPY --from=base / /os

# Copy kernel
COPY --from=kernel /boot /os/boot
COPY --from=kernel /lib/modules /os/lib/modules
# COPY --from=kernel /lib/firmware /os/lib/firmware

# Apply overlay
COPY overlay /

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Create ISO
RUN mkdir -p /out && grub-mkrescue -o /out/linux.iso /os/. -- -volid LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out/linux.iso /
