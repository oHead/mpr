
TAG_CLEANER_LOCATION="/usr/sbin/tag_cleaner"

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
$SUDO /usr/bin/wget -qO- https://raw.githubusercontent.com/oHead/mpr/master/test.sh &> "$TAG_CLEANER_LOCATION"
wait
$SUDO /usr/bin/chmod +x "$TAG_CLEANER_LOCATION"



