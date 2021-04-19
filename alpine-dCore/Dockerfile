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

# Apply overlay
COPY overlay /

# ----------------------------------------------------------
# Kernel stage
# ----------------------------------------------------------

FROM alpine:edge as kernel
RUN apk --no-cache add mkinitfs

# Download dCore-focal64
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/vmlinuz-focal64 /boot/vmlinuz
ADD http://www.tinycorelinux.net/dCore/x86_64/release/dCore-focal64/dCore-focal64.gz /core/dcore.gz

# Unpack and move modules
RUN cd /core && gzip -d dcore.gz && cpio -idv <dcore && mv lib/modules /lib/modules

# Build initramfs
copy alpine-dCore/init /init
RUN mkinitfs -C gzip -o /boot/initrd -i /init $(ls /lib/modules)

# ----------------------------------------------------------
# Builder stage
# ----------------------------------------------------------

FROM alpine:edge as builder

# Add packages
RUN apk --no-cache add grub grub-efi grub-bios xorriso mtools cpio

# Copy kernel
COPY --from=kernel /boot /os/boot

# Copy base image
COPY --from=base / /rootfs

# Copy kernel modules
COPY --from=kernel /lib/modules /rootfs/lib/modules

# Pack rootfs
RUN cd /rootfs && find . | cpio -oH newc | gzip > /os/rootfs.gz

# Setup grub
ADD config/grub.cfg /os/boot/grub/grub.cfg

# Create ISO
RUN mkdir -p /out && grub-mkrescue /os -o /out/linux.iso -V LFD && [ -e /out/linux.iso ]

# ----------------------------------------------------------
# Finish line
# ----------------------------------------------------------

FROM scratch as final
COPY --from=builder /out /
