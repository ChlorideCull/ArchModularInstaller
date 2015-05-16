lvmused=1

function doFormat {
	disknod="$1"
	echo "Select file system:"
	echo "LVM Swap $(find /usr/bin/ -name 'mkfs.*' -printf '%f ')" > /tmp/inst_dfl
	doFullList "/tmp/inst_dfl"
	if [[ "$doFullList_ret" == "LVM" ]]; then
		lvmused=0
		echo "------------"
		pvcreate "$disknod"
		echo "------------"
		echo -n "Create new volume group or use existing? (y/<existing group name) "
		read mkvg
		if [[ "$mkvg" == "y" ]]; then
			echo -n "Volume Group Name? "
			read vgname
			echo "------------"
			vgcreate "$vgname" "$disknod"
			echo "------------"
			doanotherlv="Yes"
			while [[ "$doanotherlv" == "Yes" ]]; do
				echo -n "Logical Volume Name? "
				read lvname
				echo -n "Size (*G)? "
				read lvsize
				echo "------------"
				lvcreate -L "$lvsize" -n "$lvname" "$vgname"
				echo "------------"
				echo "Format?"
				select shouldformat in Yes No; do
					if [[ "$shouldformat" == "Yes" ]]; then
						doFormat "/dev/mapper/${vgname}-${lvname}"
					fi
				done
				echo "Create another logical volume?"
				select doanotherlv in Yes No; do
					break;
				done
			done
		else
			echo "------------"
			vgextend "$mkvg" "$disknod"
			echo "------------"
		fi
	elif [[ "$doFullList_ret" == "Swap" ]]; then
		mkswap "$disknod"
	else
		echo "------------"
		"$doFullList_ret" "$disknod"
		echo "------------"
		echo
		echo "Mount point?"
		select mpoint in / /home /boot; do
			mkdir -p "/mnt/system$mpoint"
			mount "$disknod" "/mnt/system$mpoint"
			return;
		done
	fi
	return;
}

keeplooping="Yes"
while [[ "$keeplooping" == "Yes" ]]; do
	echo
	echo "---- Step 2 ----   Partition   ----"
	echo "Step 2 and 3 repeats until you have finished all partitions."
	echo "* MAKE SURE TO SET THE BOOTABLE FLAG WITH a ON THE BOOT/ROOT PARTITION *"
	echo "* IF YOU WILL USE LVM, SET PARTITION TYPE TO 8e                        *"
	echo
	echo "Skip" > /tmp/inst_dfl
	for disknod in "sd" "vd" "hd"; do
		find /dev -name "${disknod}*[^0-9]" >> /tmp/inst_dfl
	done
	mv /tmp/inst_dfl /tmp/inst_dfl_item
	tr '\n' ' ' < /tmp/inst_dfl_item > /tmp/inst_dfl
	doFullList "/tmp/inst_dfl"
	disks=$(cat /tmp/inst_dfl)
	rm /tmp/inst_dfl /tmp/inst_dfl_item
	if [[ "$doFullList_ret" != "Skip" ]]; then
		echo "------------"
		fdisk "$doFullList_ret"
		echo "------------"
	fi

	echo
	echo "---- Step 3 ----     Format    ----"
	echo "Select partition:"
	echo -n "" > /tmp/inst_dfl
	for disknod in "sd" "vd" "hd"; do
		 find /dev -name "${disknod}*[0-9]"  >> /tmp/inst_dfl
	done
	mv /tmp/inst_dfl /tmp/inst_dfl_item
	tr '\n' ' ' < /tmp/inst_dfl_item > /tmp/inst_dfl
	doFullList "/tmp/inst_dfl"
	
	doFormat "$doFullList_ret"
	
	echo
	echo "Do another partition?"
	select keeplooping in Yes No; do
		break;
	done
done

echo
echo "Install bootloader on:"
echo "(You most likely want the disk that /boot resides on, or it's LVM physical volume)"
echo "$disks" | sed 's/Skip//' > /tmp/possibledevs
doFullList "/tmp/possibledevs"
exportPostInstall bootloader_install "$doFullList_ret"