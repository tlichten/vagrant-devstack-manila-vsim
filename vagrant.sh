#!/usr/bin/env bash

# Include configuration variables
. /vagrant/vsim.conf

export OS_USER=vagrant
export NODE_MGMT_IP=$NODE_MGMT_IP

# run script
sh /vagrant/devstack.sh
