pacman -Sy --noconfirm grub os-prober

grub-install "$bootloader_install"
grub-mkconfig > /boot/grub/grub.cfg

