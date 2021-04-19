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

FROM alpine:edge as kernel
RUN apk --no-cache add mkinitfs

# Download dCore-focal64
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/vmlinuz-focal64 /boot/vmlinuz
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/dCore-focal64.gz /core/dcore.gz

RUN strings /boot/vmlinuz | grep tinycore | awk '{print $1}' >/boot/version

# Unpack and move modules
RUN cd /core && gzip -d dcore.gz && cpio -idv <dcore && mv lib/modules /lib/modules

# Build initramfs
RUN mkinitfs -C gzip -o /boot/initrd $(cat /boot/version)

# Ram version
copy alpine-dCore/config/initram /initram
RUN mkinitfs -C gzip -o /boot/initrd-ram -i /initram $(cat /boot/version)

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:edge as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools

# Copy base image
COPY --from=base / /os

# Apply overlay
COPY overlay /os

# Setup grub
ADD alpine-dCore/config/grub.cfg /os/boot/grub/grub.cfg

# Copy kernel
COPY --from=kernel /boot /os/boot
COPY --from=kernel /lib/modules /os/lib/modules

# Create ISO
RUN mkdir -p /out && grub-mkrescue /os -o /out/linux.iso -V LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out /
