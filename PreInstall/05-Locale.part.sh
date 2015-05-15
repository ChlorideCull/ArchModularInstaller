echo
echo "Select locale to use"
grep -E '(.+) UTF-8' /etc/locale.gen | sed 's/# *//g' | cut -d' ' -f1 | tr '\n' ' ' > /tmp/inst_dfl
doFullList "/tmp/inst_dfl"
exportPostInstall locale "$doFullList_ret"