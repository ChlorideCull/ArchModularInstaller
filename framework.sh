#!/bin/bash
set -u
set -e

doFullList_ret=""
function doFullList {
	xargs -d ' ' -n 6 echo < "$1" > "${1}_pretty"
	keylayoutsnums=$(wc -l < "${1}_pretty")
	tmpforloop=0
	while [[ $tmpforloop -lt $keylayoutsnums ]]; do
		tmpforloop=$tmpforloop+1;
		select doFullList_ret in Search Custom $(awk "NR==$tmpforloop" < "${1}_pretty") More; do
			if [[ "$doFullList_ret" == "More" ]]; then
				break
			elif [[ "$doFullList_ret" == "Custom" ]]; then
				echo -n "Manually enter value: "
				read doFullList_ret
				return
			elif [[ "$doFullList_ret" == "Search" ]]; then
				echo -n "Enter query: "
				read query
				xargs -d ' ' -n 1 echo < "$1" | grep "$query" | tr '\n' ' ' > "${1}_pretty"
				cp "${1}_pretty" "$1"
				doFullList "$1"
				return
			fi
			return
		done
	done
	if [[ "$doFullList_ret" == "More" ]]; then
		doFullList "$1"
	fi
}

function exportPostInstall {
	echo "${1}=\"${2}\"" >> /tmp/postInstallVars
}

#STAGE1MARKER

cat > /mnt/system/root/stage2.sh << EOF
#!/bin/bash
set -u
set -e
#CONFIG START
EOF
cat /tmp/postInstallVars >> /mnt/system/root/stage2.sh
cat >> /mnt/system/root/stage2.sh << EOF
#CONFIG END
#--- The script below is automatically generated from PostInstall scripts ---
#STAGE2MARKER

EOF
chmod +x /mnt/system/root/stage2.sh
arch-chroot /mnt/system/ /usr/bin/sh /root/stage2.sh
echo "All done! Hit enter to reboot the system."
read whyareyoulookingatthis
shutdown -r now