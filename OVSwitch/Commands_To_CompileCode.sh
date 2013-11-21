#To get the OVSwitchServer code:
#-------------------------------
wget http://openvswitch.org/releases/openvswitch-1.10.0.tar.gz
tar zxvf openvswitch-1.10.0.tar.gz

#To compile the code as per your kernel version:
#----------------------------------------------
cd openvswitch-1.10.0
./boot.sh
#default version is "Linux MegaMind 3.8.0-19-generic"
./configure --with-linux=/lib/modules/`uname -r`/build
make && make install

#once the code is compiled as per the Box's kernel version it s ready to use
#OPEN VSWITCH CONFIGURATION (all commands from openvswitch-1.10.0 folder)
#--------------------------
touch /usr/local/etc/ovs-vswitchd.conf
mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

#starting OVSwitch server:
#--------------------------
ovsdb-server /usr/local/etc/openvswitch/conf.db \
--remote=punix:/usr/local/var/run/openvswitch/db.sock \
--remote=db:Open_vSwitch,manager_options \
--private-key=db:SSL,private_key \
--certificate=db:SSL,certificate \
--bootstrap-ca-cert=db:SSL,ca_cert --pidfile --detach --log-file

#Only need to run this the first time for configuration
ovs-vsctl --no-wait init

#Start vswitch
ovs-vswitchd --pidfile <--detach: optional >


#command to check the status of OVS:
------------------------------------
ps -es | grep ovs




