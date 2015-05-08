# -*- mode: ruby -*-
# vi: set ft=ruby :

# Include vagrant-vsim. One service vm and once vsim vm will be started
vsim_vagrantfile = 'lib/vagrant-vsim/Vagrantfile' 
load vsim_vagrantfile

DEVSTACK_HOST_IP ||= "192.168.33.10"
DEVSTACK_MGMT_IP ||= NODE_MGMT_IP.rpartition(".")[0] + ".252"

Vagrant.configure(2) do |config|
  config.vm.define "devstackvm" do |devstackvm|
    devstackvm.vm.box = "ubuntu/trusty64"
    devstackvm.vm.hostname = "devstack"

    devstackvm.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "3"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end

    devstackvm.vm.network "private_network", ip: DEVSTACK_HOST_IP
    devstackvm.vm.network "private_network", ip: DEVSTACK_MGMT_IP

    devstackvm.vm.provision :shell, :path => "vagrant.sh", :args => DEVSTACK_HOST_IP

    if Vagrant.has_plugin?("vagrant-cachier")
      devstackvm.cache.scope = :box
    end
  end
end
