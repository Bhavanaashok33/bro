#!/bin/bash
#
# This supports both offline and online installation of BRO packages.
# For offline use, transfer the bundle to the deployment machine.
# To bundle currently installed bro packages use 'bro-pkg bundle bro-packages.bundle'
# Transfer bro-packages.bundle using ssh, usb or any other medium and then unbundle it.

if [ $# -ne 2 ]
  then
    echo "$0 <online|offline> <pkg_name | bundle>"
    exit 1
fi

PACKAGE=$2

case "$1" in
online)
    sudo bro-pkg install $PACKAGE < yes
    ;;
offline)
    sudo bro-pkg unbundle $PACKAGE < yes
    ;;

esac

sudo /usr/local/bro/bin/broctl deploy
sudo /usr/local/bro/bin/broctl status
