Start OVServer
----------------
cd openVswitchFOLDER
insmod datapath/linux/openvswitch.ko
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
ovsdb-server -v --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --private-key=db:SSL,private_key --certificate=db:SSL,certificate --pidfile --detach --log-file
ovs-vsctl --no-wait init
ovs-vswitchd --pidfile

Open new Tab:
-----------
ovs-vsctl show

To verify:
--------------
ps -ef| grep ovs



Add controller:
-----------------
ovs-vsctl set-controller br-int tcp:192.168.1.208:6633


Automated Scripts for VMs:
--------------------------
1. $nano /etc/ovs-ifup 
----------
#!/bin/sh 
switch='eth0' 
/sbin/ifconfig $1 0.0.0.0 up
ovs-vsctl add-port ${switch} $1

2. $nano /etc/ovs-ifdown
------------------------
#!/bin/sh 
switch='eth0'
/sbin/ifconfig $1 0.0.0.0 down 
ovs-vsctl del-port ${switch} $1
 


VMBoxManager commands:
-----------------------
wget http://wiki.qemu.org/download/linux-0.2.img.bz2
bunzip2 linux-0.2.img.bz2
VBoxManage convertdd linux-0.2.img linux-0.2.vdi



Start VMs:
------------
Host1
kvm -m 256 -net nic,macaddr=00:00:00:00:cc:10 -net tap,script=/etc/ovs-ifup,downscript=/etc/ovs-ifdown -hda 

Host2
kvm -m 256 -net nic,macaddr=00:11:22:CC:CC:10 -net tap,script=/etc/ovs-ifup,downscript=/etc/ovs-ifdown -cdrom ubuntu-12.04-desktop-amd64.iso

Host3
kvm -m 256 -net nic,macaddr=22:22:22:00:cc:10 -net tap,script=/etc/ovs-ifup,downscript=/etc/ovs-ifdown -cdrom ubuntu-12.04-desktop-amd64.iso

