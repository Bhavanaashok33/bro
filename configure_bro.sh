#!/bin/bash
#
# Scripts to configure  BRO
if [ $# -ne 3 ]
  then
    echo "$0 <interface> <lb_processes> <pin_cpu_list>"
    exit 1
fi
INTERFACE=$1
LB_PROCESSES=$2
CPU_LIST=$3

echo " * set node.cfg in bro"
sudo cp node.cfg  /usr/local/bro/etc/node.cfg
sudo cp broctl.cfg /usr/local/bro/etc/broctl.cfg
sudo ifconfig eth1 up

sudo echo "redef LogAscii::use_json = T;" >> /usr/local/bro/share/bro/base/frameworks/logging/writers/ascii.bro
sudo echo "@load packages" >> /usr/local/bro/share/bro/site/local.bro
sudo echo "redef ignore_checksums = T;" >> /usr/local/bro/share/bro/site/local.bro
sleep 2 #settle down time

sudo sed -i "s/_INTERFACE_/$INTERFACE/" /usr/local/bro/etc/node.cfg
sudo sed -i "s/_LOAD_BALANCE_PROCESSES_/$LB_PROCESSES/" /usr/local/bro/etc/node.cfg
sudo sed -i "s/_CPU_LIST_/$CPU_LIST/" /usr/local/bro/etc/node.cfg
echo " * BRO configuration complete"

sleep 2 #settle down time
. $HOME/.profile
sleep 2 #settle down time

sudo /usr/local/bro/bin/broctl install

sudo systemctl enable logstash.service
sudo systemctl enable bro.service
sudo systemctl daemon-reload
sudo systemctl restart logstash.service
sudo systemctl restart bro.service
cd $HOME

git clone https://github.com/bro/package-manager.git
cd package-manager
sudo python setup.py install
sleep 2 #settle down time
sudo bro-pkg autoconfig
cd $HOME
