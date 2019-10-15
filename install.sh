#!/usr/bin/env bash

TAG_CLEANER_LOCATION="/usr/sbin/tag_cleaner"
/usr/bin/wget -q  https://raw.githubusercontent.com/oHead/mpr/master/cleaner.sh --output-document=$TAG_CLEANER_LOCATION
wait $!
/usr/bin/chmod +x "$TAG_CLEANER_LOCATION"
