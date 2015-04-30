# vagrant-devstack-manila-vsim

Use [Vagrant](https://www.vagrantup.com) to automatically build an OpenStack Manila environment including NetApp clustered Data ONTAP simulator backend 

##### About
This project is the foundation for the automation lab used as part of the OpenStack Libery Design Summit session [Manila: Taking OpenStack Shared File Storage to the Telco Cloud](https://openstacksummitmay2015vancouver.sched.org/event/db27df3cc6ad23a28830be858cfd618d)                 

##### Table of Contents
* [System requirements](#system-requirements)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Usage](#usage)
* [Customization](#customization)
  * [Networking](#networking)
  * [Proxy and Caching](#proxy-and-caching)
  	* [Vagrant Proxyconf](#vagrant-proxyconf)
  	* [Vagrant Cachier](#vagrant-cachier)
* [Uninstall](#uninstall)
* [Known issues](#known-issues)

## System requirements

 - 8 GB RAM
 - 15-20 GB of free disk space
 - SSD recommended
 - Linux / Mac 
 - Internet connection

## Prerequisites

 - [Virtualbox](https://www.virtualbox.org/wiki/Downloads) installed
 - [Vagrant](https://www.vagrantup.com/downloads.html) installed
 - Access to the NetApp support site to download the cDOT simulator. Site access may be limited to customers and partners.

## Installation

 - If you use [Git](http://git-scm.com/), clone this repo. If you don't use Git, [download](https://github.com/tlichten/vagrant-devstack-manila-vsim/archive/master.zip) the project and extract it.
 - Download [*Clustered Data ONTAP 8.x Simulator for VMware Workstation, VMware Player, and VMware Fusion*](http://mysupport.netapp.com/NOW/download/tools/simulator/ontap/8.X/). Version 8.2.3 has been tested.
 - Save the downloaded file ```vsim_netapp-cm.tgz``` to this project's root directory, e.g. ```~/vagrant-vsim/vsim_netapp-cm.tgz```
 - Configure the Cluster base license.  
 Edit ```vsim.conf```, at the top set the 8.x Cluster base license within ```CLUSTER_BASE_LICENSE``` accordingly. The license can be obtained from the [support site](http://mysupport.netapp.com/NOW/download/tools/simulator/ontap/8.X/).  
`vsim.conf`: 
```bash
...
# Specify the Cluster Base License
# Important: Use the Cluster Base license for Clustered-ONTAP Simulator 8.x for
# VMware Workstation, VMware Player, and VMware Fusion
CLUSTER_BASE_LICENSE="SMKXXXXXXXXXXXXXXXXXXXXXXXXX"
...
```
**Important**: Use the **non-ESX build** license. 
- Configure additional licenses required for Manila
Configure the additional, required licenses CIFS, NFS, FlexClone for the use with Manila
The additional licenses can be obtained from the [support site](http://mysupport.netapp.com/NOW/download/tools/simulator/ontap/8.X/).  
`vsim.conf`: 
```bash
...
# Define additional licenses,e.g. NFS, CIFS, as a comma seperated list without spaces
# Important: Use the licenses for the non-ESX build for the first node in a cluster
LICENSES="YVUXXXXXXXXXXXXXXXXXXXXXXXXX,SOHXXXXXXXXXXXXXXXXXXXXXXXXX,MBXXXXXXXXXXXXXXXXXXXXXXXXXX"
...
```
**Important**: Use the **non-ESX build** licenses. 


## Usage

 - From this directory, e.g.  ```~/vagrant-devstack-manila-vsim/```, run:
```bash
$ vagrant up
```
 - You will be asked to import the simulator as a Vagrant box on first run. Press ```y``` to proceed and import. The import will take a few minutes.
 - During the deployment, a service VM will be started. The service VM will offer an ip address to the simulator and configure the VSim.
 - After the VSim has been deployed, a DevStack VM will be provisioned. The DevStack run will take about 40 minutes depending on the speed of your internet connection.
 - Wait until the deployment is ready. Once ready, to access the DevStack console run:
```bash
$ vagrant ssh devstackvm
```
- To access the Horizon dashboard, point your browser to http://192.168.10.30. The admin credentials are username admin, password devstack. The demo credentials are username demo, password devstack  
- As the demo user you can create a share network on your private network, and then create a share on that share network.
- TODO: Explain usage in greater detail
- When done, you can destroy the entire environment. Run:
```bash
$ vagrant destroy
```

## Customization

##### Networking  
The simulator will automatically be configured with a node-mgmt lif as well as a cluster-mgmt lif. You can customize the IP address of that lif to match your Vagrant networking setup.  
**Please note**: A dnsmasq process is used to offer the IP to the simulator. Please ensure you don't have a conflicting DHCP server on the same VBoxNet.  
`vsim.conf`: 
```ruby
...
# Host address for the VSim node auto mgmt lif which exposes ONTAPI
# Note: A cluster mgmt lif will be created with the address x.x.x.4 and an
# 	additional service vm will deployed w/ the host address of x.x.x.253
NODE_MGMT_IP="10.0.207.3"
...
```

##### Proxy and Caching

Add Vagrant plugins for the use with proxies and to enable caching

###### Vagrant Proxyconf  
If you are behind a proxy, you may want to install [Vagrant Proxyconf](https://github.com/tmatilai/vagrant-proxyconf)  
```
vagrant plugin install vagrant-proxyconf
```

###### Vagrant Cachier  
To speed up the deployment and avoid unnecessary downloads, install  [Vagrant Cachier](https://github.com/fgrehm/vagrant-cachier)  
```
vagrant plugin install vagrant-cachier
```

## Uninstall

 - From this directory, e.g.  ```~/vagrant-vsim/```, run:
```bash
$ vagrant destroy
$ vagrant box remove VSim
$ vagrant box remove ubuntu/trusty64
```
 - Uninstall Virtualbox and Vagrant

## Known issues

 - There is almost **no error handling** in place, please do not just abort the program when things take a while. At first start, please be patient, preparing the VSim Vagrant box can take several minutes.
 - Occassionaly, ```vagrant destroy``` will error and can not delete all VM disks. These stale VMs may consume significant disk space. Manual deletion is required. Delete those VMs from your Virtualbox directory, e.g. `~\VirtualBox VMs`
 - The setup is currently limited to a single node cluster
 - Setup on Windows doesn't work reliably

```license
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
