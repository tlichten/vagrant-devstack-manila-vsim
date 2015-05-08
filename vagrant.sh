#!/usr/bin/env bash
export HOST_IP=$1
export OS_HOST_IP=$HOST_IP
# Include configuration variables
. /vagrant/vsim.conf

export OS_USER=vagrant
export NODE_MGMT_IP=$NODE_MGMT_IP


# run script
sh /vagrant/devstack.sh
