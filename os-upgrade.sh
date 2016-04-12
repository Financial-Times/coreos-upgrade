#!/bin/bash

# DO NOT MOVE THIS FILE. IT GETS PULLED FROM RAW GITHUB LOCATION

# Check for updates
update_engine_client -check_for_update

# Random 10M delay before restarting (trying to stagger the restarts)
delay=`/usr/bin/expr $RANDOM % 600`
rebootflag='NEED_REBOOT'

# Sleep 120S waiting for download
sleep 120

if update_engine_client -status | grep $rebootflag;
then
echo -n "etcd is "
    if systemctl is-active etcd;
    then
        echo "Update reboot with locksmithctl."
        locksmithctl reboot
    else
        echo "Update reboot in $delay seconds."
        sleep $delay
        reboot
    fi
fi
echo "No reboot flag: [$rebootflag] found"
exit 0

