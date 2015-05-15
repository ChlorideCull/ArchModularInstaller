find /usr/share/kbd/keymaps/ -type f -printf '%f ' > /tmp/inst_dfl
echo "---- Step 1 ---- Select Keymap ----"
doFullList "/tmp/inst_dfl"
loadkeys "$doFullList_ret"
exportPostInstall keymap "$doFullList_ret"
