+++
title = 'NFS on Ubuntu'
image = '/images/post/nfs.png'
author = 'Naim'
date = 2017-05-08
description = 'How to install NFS on Ubuntu'
categories = ["nfs","ubuntu"]
type = 'post'
+++

Network File System (NFS) is a distributed file system protocol originally developed by Sun Microsystems (Sun) in 1984, allowing a user on a client computer to access files over a computer network much like local storage is accessed.

Table of Contents
=================

* [NFS Server](#nfs-server)
  * [Mount](#mount)
  * [Private Share](#private-share)
  * [Public Share](#public-share)
  * [Enable NFS Server](#enable-nfs-server)
  * [Allow firewall](#allow-firewall)
* [NFS Client](#nfs-client)


## NFS Server

```bash
sudo apt update && sudo apt install nfs-kernel-server
```



### Mount

Verify connected USB device:

```bash
lsblk
```

Output:

```
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                         8:0    0 111.8G  0 disk
├─sda1                      8:1    0   512M  0 part /boot/efi
├─sda2                      8:2    0     1G  0 part /boot
└─sda3                      8:3    0 110.3G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0  55.1G  0 lvm  /
sdb                         8:16   0 931.5G  0 disk
└─sdb1                      8:17   0 931.5G  0 part
```

Create directory for share

```bash
mkdir /home/naim/nfs
```

Mount disk

```bash
sudo mount /dev/sdb1 /home/naim/nfs
```

NFS will translate any **root** operations on the **client** to the `nobody:nogroup` credentials as a security measure. Therefore, we need to change the directory ownership to match those credentials.

```bash
sudo chown nobody:nogroup /home/naim/nfs
```


### Private Share

Provide  the read, write and execute privileges to all the contents inside the directory.

```bash
sudo chmod 777 /home/naim/nfs
```

NFS exports config:

```bash
sudo sh -c "echo '/home/naim/nfs 192.168.0.0/24(rw,sync,no_subtree_check,insecure)' >> /etc/exports"
```

Explanation about the options used in the above command.

- `home/naim/nfs`: sharing folder path.
- `192.168.0.0/24`: allowed en entire subnet to have access to the NFS share.
- `rw`: Stands for Read/Write.
- `sync`: Requires changes to be written to the disk before they are applied.
- `No_subtree_check`: Eliminates subtree checking.

Then apply the new settings by running the following command. This will export all directories listed in /etc/exports file.

```bash
sudo exportfs -arvf
```



### Public Share

Provide  the read and execute privileges to all the contents inside the directory.

```bash
sudo chmod 755 /home/naim/nfs
```

NFS exports config:

```bash
sudo sh -c "echo '/home/naim/nfs *(ro,no_subtree_check,insecure)' >> /etc/exports"
```

Explanation about the options used in the above command.

- `home/naim/nfs`: sharing folder path.
- `**`: allowed any network and IP to have access to the NFS share.
- `ro`: Stands for Read Only.
- `No_subtree_check`: Eliminates subtree checking.
- `insecure`: Stands for no password check.

Then apply the new settings by running the following command. This will export all directories listed in /etc/exports file.

```bash
sudo exportfs -arvf
```



### Enable NFS Server

```bash
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
sudo systemctl status nfs-kernel-server
```



### Allow firewall

```bash
sudo ufw allow from 192.168.0.0/24 to any port nfs
OR
sudo ufw allow nfs
```





## NFS Client

Install the NFS-Common Package to mount nfs share on client.

```bash
sudo apt update && sudo apt install nfs-common
```

Mount

```bash
sudo mount 192.168.0.100:/home/naim/nfs /mnt/nfs
OR
sudo mount -t nfs -o resvport 192.168.0.100:/home/naim/nfs /mnt/nfs
```
