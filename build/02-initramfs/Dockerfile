# ----------------------------------------------------------
# Initramfs stage
# ----------------------------------------------------------

FROM archlinux:base as initrd
RUN pacman -Sy --noconfirm mkinitcpio

# Configure mkinitcpio.conf
COPY config/mkinitcpio.conf /etc/mkinitcpio.conf

# Add Build hook
COPY config/buildhook.sh /etc/initcpio/install/rootfs

# Add Runtime hook
COPY config/runhook.sh /etc/initcpio/hooks/rootfs

# Copy kernel with modules
COPY --from=kernel /boot /boot
COPY --from=kernel /lib/modules /lib/modules
# COPY --from=kernel /lib/firmware /lib/firmware

# Create a list of module dependencies
RUN depmod $(ls /lib/modules)

# Build initramfs
RUN mkinitcpio --generate /boot/initrd.img --kernel $(ls /lib/modules)