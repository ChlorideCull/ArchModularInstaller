echo
echo Select time zone
curdir="$PWD"
cd /usr/share/zoneinfo
find . -type f -printf '%p ' > /tmp/inst_dfl
cd "$curdir"
doFullList "/tmp/inst_dfl"
exportPostInstall tz "$doFullList_ret"
