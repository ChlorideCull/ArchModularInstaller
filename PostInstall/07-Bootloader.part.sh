pacman -Syu --noconfirm grub os-prober
if [[ "$bootloader_lvm" == "0" ]]; then
	mkdir -p /run/lvm
	lvmetad
fi
grub-install "$bootloader_install"
grub-mkconfig > /boot/grub/grub.cfg
