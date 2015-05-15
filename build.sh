#!/bin/sh
rm /tmp/preinstallscript /tmp/postinstallscript
cd PreInstall/
for script in *.part.sh; do
	cat "$script" >> /tmp/preinstallscript
	echo >> /tmp/preinstallscript
done
cd ../PostInstall/
for script in *.part.sh; do
	sed 's/\$/\\$/g' "$script" >> /tmp/postinstallscript
	echo >> /tmp/postinstallscript
done
cd ..
sed '/#STAGE2MARKER/r /tmp/postinstallscript' framework.sh | sed '/#STAGE1MARKER/r /tmp/preinstallscript' > install.sh
chmod +x install.sh