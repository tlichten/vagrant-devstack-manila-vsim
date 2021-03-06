#!/usr/bin/env bash
. /vagrant/vsim.conf
BASEIP=`echo $NODE_MGMT_IP | cut -d"." -f1-3`
DEVSTACK_MGMT_IP="$BASEIP.252"

# Network plumbing
sudo ip addr del $DEVSTACK_MGMT_IP/24 dev eth2
sudo ovs-vsctl add-port br-ex eth2
sudo ip link set eth2 up
sudo ip link set eth2 promisc on
sudo ip addr add $DEVSTACK_MGMT_IP/24 dev br-ex
sudo iptables -t nat -A POSTROUTING -o br-ex -j MASQUERADE

# If you installed Horizon on this server you should be able
# to access the site using your browser.
echo "Horizon is now available at http://$HOST_IP/"
echo "The default users are: admin and demo"
echo "The password: $OPENSTACK_ADM_PASSWORD"
echo "VSim available running: vagrant ssh vsim"
echo "Devstack VM console available running: vagrant ssh devstackvm"
