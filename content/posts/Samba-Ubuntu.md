+++
title = 'Samba on Ubuntu'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2017-04-11
description = 'Setting up Samba on Ubuntu'
categories = ["samba","ubuntu"]
type = 'post'
+++


Samba is a free software re-implementation of the SMB networking protocol, and was originally developed by Andrew Tridgell. Samba provides file and print services for various Microsoft Windows clients and can integrate with a Microsoft Windows Server domain, either as a Domain Controller or as a domain member.


###### Install samba

```bash
sudo apt install samba -y
```

###### Create a folder to share
```bash
sudo mkdir /share
sudo chmod 777 /share
```

###### Edit samba config file
```bash
sudo nano  /etc/samba/smb.conf
```

###### Add followings end of the samba config file
```config
[samba-server]
	path = /share
	public = no
	valid users = naim, prithwi
	read list = prithwi
	write list = naim
	browseable = yes
	comment = "Samba File Server"
```

###### Test config
```bash
sudo testparm
```

###### Create samba user without login permission
```
sudo useradd naim -s /sbin/nologin
sudo useradd prithwi -s /sbin/nologin
```

###### Create samba user password
```
sudo smbpasswd -a naim
sudo smbpasswd -a prithwi
```

###### Enable smbd and nmbd
```
sudo systemctl start smbd
sudo systemctl start nmbd
sudo systemctl enable smbd nmbd
```

###### Allow samba from firewall
```
sudo ufw allow from 10.8.0.1/24 to any app Samba
```

