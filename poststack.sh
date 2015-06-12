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

. devstack/openrc admin
# Volume Types
cinder type-create iscsi
cinder type-create nfs
cinder type-create gold
cinder type-create silver
cinder type-create bronze
cinder type-create analytics
cinder type-create protected
cinder type-create throttled
cinder type-create thinprovisioned
cinder type-key iscsi set storage_protocol=iSCSI
cinder type-key nfs set storage_protocol=nfs
cinder type-key gold set netapp_dedup=false
cinder type-key gold set netapp_compression=false
cinder type-key gold set netapp_thin_provisioned=false
cinder type-key gold set storage_protocol=nfs
cinder type-key silver set netapp_dedup=true
cinder type-key silver set netapp_compression=false
cinder type-key bronze set netapp_compression=true
cinder type-key bronze set netapp_dedup=true
cinder type-key analytics set volume_backend_name=cdot-iscsi
cinder type-key protected set netapp_mirrored=true
cinder type-key throttled set netapp:qos_policy_group=service_class_throttled
cinder type-key thinprovisioned set netapp_thin_provisioned=true
cinder extra-specs-list

# Manila Horizon UI
cd /opt/stack && git clone -b $MANILA_UI_BRANCH https://github.com/openstack/manila-ui
cd /opt/stack/horizon && cp openstack_dashboard/local/local_settings.py.example openstack_dashboard/local/local_settings.py
sed -i "s/'js_spec_files': \[\],/'js_spec_files': \[\],\n'customization_module': 'manila_ui.overrides',/" /opt/stack/horizon/openstack_dashboard/local/local_settings.py
sudo -H pip install -e /opt/stack/manila-ui
cd /opt/stack/horizon && cp ../manila-ui/manila_ui/enabled/_90_manila_*.py openstack_dashboard/local/enabled
sudo /etc/init.d/apache2 restart 2>/dev/null

# Modify Tempest conf 
sed -i "s/allow_tenant_isolation = True/allow_tenant_isolation = False/" /opt/stack/tempest/etc/tempest.conf

# If you installed Horizon on this server you should be able
# to access the site using your browser.
echo "Horizon is now available at http://$HOST_IP/"
echo "The default users are: admin and demo"
echo "The password: $OPENSTACK_ADM_PASSWORD"
echo "VSim available running: vagrant ssh vsim"
echo "Devstack VM console available running: vagrant ssh devstackvm"
