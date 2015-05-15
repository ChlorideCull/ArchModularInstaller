echo "$hstnme" > /etc/hostname
ln -sf "/usr/share/zoneinfo/$tz" /etc/localtime

echo "KEYMAP=$keymap" > /etc/vconsole.conf
echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf

pacman -Sy --noconfirm grub os-prober

grub-install "$bootloader_install"
grub-mkconfig > /boot/grub/grub.cfg

echo "$locale" >> /etc/locale.gen
locale-gen

mkinitcpio -p linux
echo "------"
echo "Set a root password"
passwd #shit doesn't work
