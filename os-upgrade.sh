#!/bin/bash

# DO NOT MOVE THIS FILE. IT GETS PULLED FROM RAW GITHUB LOCATION

# Stop serving read requests (aggregate-healthchck to return unhealthy on `__gtg` calls
etcdctl set /ft/healthcheck-categories/read/enabled false

# Check for updates
update_engine_client -check_for_update

# Random 10M delay before restarting (trying to stagger the restarts)
delay=`/usr/bin/expr $RANDOM % 600`
rebootflag='NEED_REBOOT'

# Sleep 240S waiting for download
sleep 240

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
else
    echo "No reboot flag: [$rebootflag] found"
fi

exit 0

