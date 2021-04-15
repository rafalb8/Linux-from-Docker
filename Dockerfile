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

FROM alpine:edge as kernel
RUN apk --no-cache add mkinitfs xz

# Download dCore-focal64
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/vmlinuz-focal64 /boot/vmlinuz
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/dCore-focal64.gz /core/dcore.gz

# Unpack and move modules
RUN cd /core && gzip -d dcore.gz && cpio -idv <dcore && mv lib/modules /lib/modules

# Build initramfs
RUN version=$(strings /boot/vmlinuz | grep tinycore | awk '{print $1}') && mkinitfs -C xz -o /boot/initrd $version

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:edge as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools

# Copy base image
COPY --from=base / /os

# Copy kernel
COPY --from=kernel /boot /os/boot
COPY --from=kernel /lib/modules /os/lib/modules
# COPY --from=kernel /lib/firmware /os/lib/firmware

# Apply overlay
COPY overlay /os

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Create ISO
RUN mkdir -p /out && grub-mkrescue /os -o /out/linux.iso -V LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out/ /
