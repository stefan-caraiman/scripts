#!/bin/bash

# Update the apt-get
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git vim openssh-server openvswitch-switch ethtool fish kvm qemu-kvm
sudo apt-get install ntp
sudo service ntp force-reload
sudo ntpd -qgddd
sudo cp interfaces /etc/network/interfaces
sudo /etc/init.d/networking restart
sudo ufw disable
sudo ifup eth1
sudo ifup eth2
sudo ethtool -K eth1 txvlan off rxvlan off
sudo ovs-vsctl add-br br-eth1
sudo ovs-vsctl add-port br-eth1 eth1
sudo ovs-vsctl add-br br-ex
sudo ovs-vsctl add-port br-ex eth2
sudo ethtool -K eth1 txvlan off rxvlan off
cd
git clone https://github.com/openstack-dev/devstack.git
cd devstack
git checkout stable/kilo
cp ~/scripts/devstack/local.conf ~/devstack/
cd ~/scripts/devstack
$rc_end="rcend"
$dst="~/.bashrc"
sudo cat "$rc_end" >> "$dst"
source ~/.bashrc
cd ~/devstack
./stack.sh
cd ~/devstack
wget https://github.com/stefan-caraiman/scripts/openstack_config.sh
chmod +x openstack_config.sh
./openstack_config.sh
nova flavor-delete 1
nova flavor-delete 2
nova flavor-delete 3
nova flavor-delete 4
nova flavor-delete 5
nova flavor-delete 42
nova flavor-delete 84
nova flavor-delete 451
nova flavor-create win-small 1 2048 40 1
nova flavor-create win-medium 2 4096 40 2
nova flavor-create win-large 3 6144 40 4
cd
git clone https://github.com/PCManticore/argus-ci
cd ~/argus-ci
git checkout develop
virtualenv .venv/argus-ci --python=/usr/bin/python2.7
source .venv/argus-ci/bin/activate
pip install pip --upgrade
pip install -r requirements.txt
python setup.py develop
cd /opt/stack/tempest/
git checkout tags/7
pip install -r requirements.txt
pip install -r test-requirements.txt
python setup.py install
cd
sudo ln -s /opt/stack/tempest/etc /etc/tempest
sudo ln -s argus-ci/etc /etc/argus

