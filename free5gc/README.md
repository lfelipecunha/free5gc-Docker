What is free5GC
================

The free5GC is an open-source project for 5th generation (5G) mobile core network. Currently, the major contributors are with National Chiao Tung University (NCTU). Although the ultimate goal of this project is to implement 3GPP Release 15 (R15) and Release 16 (R16) 5G core network (5GC), in current version we only implement three most important components in 5GC, namely Access and Mobility Management Function (AMF), Session Management Function (SMF) and User Plane Function (UPF). Thus, current version is mainly for the enhance Mobile Broadband (eMBB). Other features such as Ultra-Reliable Low Latency Connection (URLLC) and Massive Internet of Things (MIoT) are not supported yet.


## Minimum Requirement
- Software
    - OS: Ubuntu 18.04
    - Linux kernel: 4.15.0-43-generic
    - gcc 7.3.0
    - Go 1.11.4
    - QEMU emulator 2.11.1

- Hardware recommended
    - CPU: Intel i5
    - RAM: 4GB
    - Hard drive: 160G
    - NIC card: 1Gbps ethernet card


## Hardware Tested 
eNB
- GemTek WLTGFC-101 (4G LTE Small Cell)

UE
- LG C90 cellular phone
- D-Link DWR-932C dongle via USB cable


## Preparation

### KVM Environment Setup

* VM NIC Cards
    1. NIC for connecting to the Internet
        * Network source: `Virtual network - NAT`
        * Interface name in VM: `ens3` (in this example)
    2. NIC for connecting to eNB:
        * Network source: Host device `<Host Interface Name>`
        * Interface name in VM: `ens4` (in this example)

### Collect eNodeB and USIM Information

* eNodeB information (in this example)  
```
	IP Address: 192.188.2.1
	Gateway:    192.188.2.2 (IP of NIC connected to eNB)
	PLMN:
	  MCC: 208
	  MNC: 93
	MME GID:  1
	MME Code: 1
	TAC: 1
```

* USIM information (in this example)  
```
IMSI 208930000000003
K    8baf473f2f8fd09487cccbd7097c6862
OPc  8e27b6af0e692e750f32667a3b14605d
```


## Installation

*You can either follow the instructions from Part A ~ Part C or simply run the shell listed in the end of this document.*

### Part A. Compile Source Code

#### Prerequisites

Install MongoDB 3.6.3, Golang 1.11.4.
```bash
sudo apt-get update
sudo apt-get -y install mongodb wget git
sudo systemctl start mongodb (if '/usr/bin/mongod' is not running)

# Check if golang is installed
go version

# If not, run commands below
wget -q https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x installer_linux
./installer_linux
source ~/.bash_profile
rm -f installer_linux

go get -u -v "github.com/gorilla/mux"
go get -u -v "golang.org/x/net/http2"
go get -u -v "golang.org/x/sys/unix"
```
To run free5GC with least privilege, TUN device permission should be a crw-rw-rw-(666). 

```bash
ls -al /dev/net/tun
crw-rw-rw- 1 root root 10, 200 Jan 14 13:09 /dev/net/tun
```

Write the configuration file for the TUN device.
```bash
sudo sh -c "cat << EOF > /etc/systemd/network/99-free5gc.netdev
[NetDev]
Name=uptun
Kind=tun
EOF"

sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd
```

Check *IPv6 Kernel Configuration*. Although you can skip this step, we suggest that you set this up to support IPv6-enabled UE.

```bash
sysctl -n net.ipv6.conf.uptun.disable_ipv6

(if the output is 0 and IPv6 is enabled, skip the followings)
sudo sh -c "echo 'net.ipv6.conf.uptun.disable_ipv6=0' > /etc/sysctl.d/30-free5gc.conf"
sudo sysctl -p /etc/sysctl.d/30-free5gc.conf
```

You are now ready to set the IP address on TUN device. If IPv6 is disabled for TUN device, please remove `Address=cafe::1/64` from below.

```bash
sudo sh -c "cat << EOF > /etc/systemd/network/99-free5gc.network
[Match]
Name=uptun
[Network]
Address=45.45.0.1/16
Address=cafe::1/64
EOF"

sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd

sudo apt-get -y install net-tools
# Check if uptun is up
ifconfig uptun
```


#### AMF, SMF, UPF, HSS, and PCRF

Install the depedencies for building the source
```bash
sudo apt-get -y install autoconf libtool gcc pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev
```

Git clone and compile
```bash
git clone https://bitbucket.org/nctu_5g/free5gc.git
cd free5gc
autoreconf -iv
./configure --prefix=`pwd`/install
make -j `nproc`
make install
```


### Part B. VM Internal Network Environment Setting
\[Option 1\] Need to run on every boot
```bash
sudo ifconfig ens4 192.188.2.2
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
sudo iptables -I INPUT -i uptun -j ACCEPT
```

\[Option 2\] or configure as auto run on boot
```bash
sudo sh -c "cat << EOF > /etc/init.d/ngc-network-setup
#!/bin/sh
### BEGIN INIT INFO 
# Provides:          ngc-network-setup 
# Required-Start:    networkd 
# Required-Stop:     networkd 
# Default-Start:     networkd 
# Default-Stop:      networkd 
# Short-Description: 
# Description:       
# 
### END INIT INFO

ifconfig ens4 192.188.2.2
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
iptables -I INPUT -i uptun -j ACCEPT
EOF"

sudo chmod 755 /etc/init.d/ngc-network-setup
sudo /etc/init.d/ngc-network-setup

sudo ln -s /etc/init.d/ngc-network-setup /etc/rc3.d/S99ngc-network-setup
sudo ln -s /etc/init.d/ngc-network-setup /etc/rc4.d/S99ngc-network-setup
sudo ln -s /etc/init.d/ngc-network-setup /etc/rc5.d/S99ngc-network-setup
```


### Part C. Run

#### Run in all-in-one mode
The daemon ``free5gc-ngcd`` includes *AMF*, *SMF*, *UPF*, *HSS*, and *PCRF*. Thus, instead of running all 5 daemons, you can just run ``free5gc-ngcd`` in your development environment.

```bash
./free5gc-ngcd
```

* While running `free5gc-ngcd`
    * All logs for AMF, SMF, UPF, HSS, and PCRF are written to `./install/var/log/free5gc/free5gc.log`.
    * All settings are managed in one place for `./install/etc/free5gc/free5gc.conf`.
    * You can find the log/conf path at the beginning of the running screen.
    * You can user ``-f`` argument to specify config file to be used.

#### \[Optional\] Self-test
We provide a program that checks whether the installation is correct.  
After running the wireshark, select `loopback` interface, and then filter `s1ap || diameter || gtpv2 || gtp` and run `./test/testngc`. You can see the packets virtually created.

```bash
./test/testngc -f install/etc/free5gc/test/free5gc.testngc.conf
```


### Part D. Web User Interface

Install [Node.js](https://nodejs.org/) and [NPM](https://www.npmjs.com/)

```bash
sudo apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get -y install nodejs
```

Install the dependencies to run WebUI (first time)

```bash
cd webui
npm install
```

Run WebUI

```bash
cd webui
npm run dev
```

Now the web server is running on _http://localhost:3000_.


## Core Network Configuration

#### free5GC configuration file
Modify `./install/etc/free5gc/free5gc.conf`

1. amf-slap address (line 67)  
```
amf:
  s1ap:
	addr: <IP of GW NIC to eNB: 192.188.2.2>
```
2. upf-gtpu address (line 162)  
```
smf:
  upf:
	addr: <IP of GW NIC to eNB: 192.188.2.2>
```
    
3. AMF GUMMEI (line 91)  
```
amf:
  gummei:
	plmn_id:
	  mcc: <eNB MCC: 208>
	  mnc: <eNB MNC: 93>
	mme_gid: <eNB MME GID: 1>
	mme_code: <eNB MME Code: 1>
```

4. AMF TAI (line 130)  
```
amf:
  tai:
	plmn_id:
	  mcc: <eNB MCC: 208>
	  mnc: <eNB MNC: 93>
	tac: <eNB TAC: 1>
```


#### Add subscriber (UE)
* Add a subscriber by the Web UI
    * Run the web server: `cd ./webui && npm run dev`
    * Visit _http://localhost:3000_  
```
  - Username : admin
  - Password : 1423
```
    * Add a subscriber with `IMSI`, `K`, `OPc`  
```
  - Go to Subscriber Menu.
  - Click `+` Button to add a new subscriber.
  - Fill the IMSI, security context(K, OPc, AMF), and APN of the subscriber.
  - Click `SAVE` Button
```
    * This addition will take effect immediately on free5GC without restaring any daemon.


## Documentation

If you don't understand something about free5GC, please refer to [http://free5gc.org](http://free5gc.org)


## Support

Problem with free5GC, please email to [mailto:free5GC.org@gmail.com]


## License

free5GC source files are made available under the terms of the GNU Affero General Public License (GNU AGPLv3).

