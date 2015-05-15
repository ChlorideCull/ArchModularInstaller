echo -n "Install development tools (y/n)? "
read devtools
if [[ "$devtools" == "y" ]]; then
	devtools="-devel"
else
	devtools=""
fi
pacstrap /mnt/system/ base$devtools
genfstab /mnt/system/ > /mnt/system/etc/fstab
