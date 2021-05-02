+++
title = 'KVM Installation on Ubuntu'
image = '/images/post/kvm.png'
author = 'Naim'
date = 2020-09-03
description = 'How to install kvm on ubuntu'
categories = ["kvm","ubuntu"]
type = 'post'
+++

KVM (Kernel-based Virtual Machine) is an open source full virtualization solution for Linux like systems, KVM provides virtualization functionality using the virtualization extensions like **Intel VT** or **AMD-V**.

Table of Contents
=================

* [Verify hardware](#verify-hardware)
* [KVM packages installation](#kvm-packages-installation)
    * [Ubuntu 18\.04](#ubuntu-1804)
    * [Ubuntu 20\.04](#ubuntu-2004)
* [User &amp; Groups settings](#user--groups-settings)
* [QEMU config](#qemu-config)
* [Network bridge](#network-bridge)
* [Create a guest instance](#create-a-guest-instance)
  * [Virt\-install usage](#virt-install-usage)
  * [Headless guest vm](#headless-guest-vm)
  * [Virt\-manager guest vm](#virt-manager-guest-vm)
* [Virsh essential command](#virsh-essential-command)
    * [List all VMs](#list-all-vms)
    * [Get VM info](#get-vm-info)
    * [Stop/shutdown a VM](#stopshutdown-a-vm)
    * [Start VM](#start-vm)
    * [Mark VM for autostart at server boot time](#mark-vm-for-autostart-at-server-boot-time)
    * [Reboot (soft &amp; safe reboot) VM](#reboot-soft--safe-reboot-vm)
    * [Reset (hard reset/not safe) VM](#reset-hard-resetnot-safe-vm)
    * [Delete VM](#delete-vm)
    * [List the current snapshots](#list-the-current-snapshots)
    * [Create a Snapshot](#create-a-snapshot)
    * [To check the details of a snapshot](#to-check-the-details-of-a-snapshot)
    * [To revert to a snapshot [snapshot restore]](#to-revert-to-a-snapshot-snapshot-restore)
    * [To delete a snapshot](#to-delete-a-snapshot)
    * [Storage Pool](#storage-pool)
    * [Mount](#mount)
    * [Listing current pools](#listing-current-pools)
    * [Destroying pool](#destroying-pool)
    * [Undefine pool](#undefine-pool)
    * [Creating a directory to host the new pool (if it does not exist)](#creating-a-directory-to-host-the-new-pool-if-it-does-not-exist)
    * [Defining a new pool with name "default"](#defining-a-new-pool-with-name-default)
    * [Set pool to be started when libvirt daemons starts](#set-pool-to-be-started-when-libvirt-daemons-starts)
    * [Start pool](#start-pool)
    * [Checking pool state](#checking-pool-state)

### Verify hardware

Verify whether your system support hardware virtualization
```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

If the output is greater than 0 then it means your system supports Virtualization else reboot your system, then go to BIOS settings and enable VT technology.



### KVM packages installation

##### Ubuntu 18.04
```bash
sudo apt install -y qemu qemu-kvm libvirt-bin virtinst libosinfo-bin bridge-utils 
```

##### Ubuntu 20.04
```bash
sudo apt install -y qemu-kvm virtinst libvirt-daemon-system libvirt-daemon libosinfo-bin bridge-utils
```


**Optional:** Install virt-manager (graphical user interface). If you are working on a desktop computer you might want to install a GUI tool to manage virtual machines.

```bash
sudo apt install -y virt-manager
```

A little explanation of the above packages.

- The **qemu** package (quick emulator) is an application that allows you to perform hardware virtualization.
- The **qemu-kvm** package is the main KVM package.
- The **libvirt-bin | libvirt-daemon** is the virtualization daemon.
- The **bridge-utils** package helps you create a bridge connection to allow other users to access a virtual machine other than the host system.
- The **virt-manager** is an application for managing virtual machines through a graphical user interface.

Before proceeding further, we need to confirm that the virtualization daemon – **libvritd** – is running. To do so, execute the command.

```bash
sudo systemctl status libvirtd
```

You can enable it to start on boot by running:

```bash
sudo systemctl enable --now libvirtd
```

To check if the KVM modules are loaded, run the command:

```bash
lsmod | grep -i kvm
```

### User & Groups settings

```bash
sudo adduser $USER libvirt && \
sudo adduser $USER kvm
```

### QEMU config

```bash
sudo cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.original
sudo sed -i 's/#.*$//;/^$/d' /etc/libvirt/qemu.conf
echo 'user = "'$USER'"' | sudo tee -a /etc/libvirt/qemu.conf > /dev/null
echo 'group = "libvirt"' | sudo tee -a /etc/libvirt/qemu.conf > /dev/null
echo 'security_driver = "none"' | sudo tee -a /etc/libvirt/qemu.conf > /dev/null
```


Restart libvirtd service

```bash
sudo systemctl restart libvirtd
```

### Network bridge

Network bridge almost like a network switch, and in a software sense, it is used to implement the concept of a “**virtual network switch**”. A typical use case of software network bridging is in a virtualization environment to connect virtual machines (VMs) directly to the host server network. This way, the VMs are deployed on the same subnet as the host and can access services such as **DHCP** and much more.

In Ubuntu 18.04, network is managed by netplan utility, whenever we freshly installed Ubuntu 18.04 server then netplan file is created under **/etc/netplan/**

```bash
ls /etc/netplan/
cat /etc/netplan/*.yaml
sudo nano /etc/netplan/*.yaml
```

As of now I have already configured the static IP via this file and content of this file is below:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
        enp2s0:
            addresses: [192.168.0.100/24]
            gateway4: 192.168.0.1
            nameservers:
              addresses: [192.168.0.1]
            dhcp4: no
            optional: true
    version: 2
```

Let’s add the network bridge definition in this file,

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp2s0:
      dhcp4: no
      dhcp6: no

  bridges:
    br0:
      interfaces: [enp2s0]
      dhcp4: no
      addresses: [192.168.0.100/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [8.8.8.8,1.1.1.1]
```

As you can see we have removed the IP address from interface (enp2s0) and add the same IP to the bridge ‘**br0**‘ and also added interface (enp2s0) to the bridge br0. Apply these changes using below netplan command:

```bash
sudo netplan try
sudo netplan --debug  apply
sudo netplan apply
sudo networkctl status -a
```

Check out IP

```bash
ip a
```



### Create a guest instance

Before creating the guest VM, we need to ensure the Guest OS is supported by the KVM, can check  by running the following command :

```bash
osinfo-query os
```



#### Virt-install usage

|                          Arguments                           |                           Remarks                            |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                        --name VM_NAME                        |                  Name of the guest instance                  |
|                        --memory 1024                         |           Configure guest memory allocation in MiB           |
|                 --memory 512,maxmemory=1024                  | Configure guest memory allocation maximum and current in MiB |
|                          --vcpus 1                           |         Number of vcpus to configure for your guest          |
|                    --vcpus 5,maxvcpus=10                     | Current and maximum number of vcpus to configure for your guest |
|                   --os-variant ubuntu18.04                   |             The OS being installed in the guest              |
|                        --disk size=10                        |     Specify storage with 10GiB image in default location     |
| --disk path=/mtn/kvm/ubuntu.qcow2,format=qcow2,bus=virtio,size=10 |        Specify storage with location, format and size        |
|                     --network bridge=br0                     |             Configure a guest network interface              |
|                       --graphics none                        |               Configure guest display settings               |
|                --cdrom /home/user/ubuntu.iso                 |                  CD-ROM installation media                   |
|       --extra-args="console=tty0 console=ttyS0,115200"       | Additional arguments to pass to the install kernel booted from --location |
|                       --check all=off                        |             Enable or disable validation checks              |
|                            --hvm                             | [Optional] This guest should be a fully virtualized guest. Create a fully-virtualized Windows guest using the command-line (`virt-install`), launch the operating system's installer inside the guest, and access the installer through `virt-viewer`. |



#### Headless guest vm

```bash
sudo virt-install \
--name Ubuntu \
--os-variant=ubuntu18.04 \
--memory 512,maxmemory=1024 \
--vcpus=1 \
--disk size=20 \
--cdrom 'iso/ubuntu-18.04.5-live-server-amd64.iso' \
--network bridge:br0 \
--hvm \
--graphics vnc,port=5901,listen=0.0.0.0
```



#### Virt-manager guest vm

```bash
sudo virt-install \
--name Ubuntu \
--os-variant=ubuntu18.04 \
--memory 512,maxmemory=1024 \
--vcpus=1 \
--disk size=20 \
--cdrom 'iso/ubuntu-18.04.5-live-server-amd64.iso' \
--network bridge:br0 \
--hvm \
--console pty,target_type=serial
```



### Virsh essential command

Let us see some useful commands for managing VMs.

###### List all VMs

```bash
sudo virsh list --all
```

###### Get VM info

```bash
sudo virsh dominfo vmname
```

###### Stop/shutdown a VM

```bash
sudo virsh shutdown vmname
```

###### Start VM

```bash
sudo virsh start vmname
```

###### Mark VM for autostart at server boot time

```bash
sudo virsh autostart vmname
```

###### Reboot (soft & safe reboot) VM

```bash
sudo virsh reboot vmname
```

###### Reset (hard reset/not safe) VM

```bash
sudo virsh reset vmname
```

###### Delete VM

```bash
export VMNAME="ubuntu"

sudo virsh shutdown ${VMNAME}
sudo virsh destroy ${VMNAME}
sudo virsh undefine ${VMNAME}
sudo virsh pool-destroy ${VMNAME}
D=/var/lib/libvirt/images
sudo rm -rf $D/${VMNAME}.qcow2
```

###### List the current snapshots

```bash
sudo virsh snapshot-list vmname
```

###### Create a Snapshot

```bash
sudo virsh snapshot-create-as --domain vmname --name "snapshot_name" --description "my description"
sudo virsh snapshot-list vmname
```

###### To check the details of a snapshot

```bash
sudo virsh snapshot-list vmname
sudo virsh snapshot-info --domain vmname --current
```

###### To revert to a snapshot [snapshot restore]

```bash
sudo virsh shutdown vmname
sudo virsh snapshot-revert --domain vmname --snapshotname "snapshot_name" --running
```

###### To delete a snapshot

```bash
sudo virsh snapshot-delete --domain vmname --snapshotname "snapshot_name"
```



###### Storage Pool

As a default, there is one storage pool which called “**Default**” uses the **rootfs** partition to store vm’s volumes under **/var/lib/libvirt/images** path.

```bash
virsh pool-list
```

###### Mount

I want to use the directory `/mnt/kvm/` which is mounted over `/dev/sda5`, as the default Storage Pool for all future situations. I will use `/dev/sda5` as my partition, you may have a different one. Make sure you have mounted it properly.

```bash
sudo mount -t ext4 /dev/sda5 /mnt/kvm/
```

###### Listing current pools

```bash
virsh pool-list
```

###### Destroying pool

```bash
virsh pool-destroy default
```

###### Undefine pool

```bash
virsh pool-undefine default
```

###### Creating a directory to host the new pool (if it does not exist)

```bash
sudo mkdir /mnt/kvm/
```

###### Defining a new pool with name "default"

```bash
virsh pool-define-as --name default --type dir --target /mnt/kvm/
```

###### Set pool to be started when libvirt daemons starts

```bash
virsh pool-autostart default
```

###### Start pool

```bash
virsh pool-start default
```

###### Checking pool state

```bash
virsh pool-list
```

