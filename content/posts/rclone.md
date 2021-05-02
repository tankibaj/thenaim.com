
+++
title = 'Sync Everything with Rclone'
image = '/images/post/rclone.png'
author = 'Naim'
date = 2020-04-10
description = 'Setting up rclone on ubuntu'
categories = ["rclone","ubuntu"]
type = 'post'
+++





Rclone syncs your files to cloud storage: Google Drive, S3, Swift, Dropbox, Google Cloud Storage, Azure, Box and many more.

Table of Contents
=================

* [Installation](#installation)
* [OVH Config](#ovh-config)
* [Mount](#mount)
* [Auto Mount on Start](#auto-mount-on-start)
* [Unmount](#unmount)
* [Check mounted disk](#check-mounted-disk)
* [List](#list)
* [Copy file](#copy-file)
* [Docs](#docs)

### Installation

```bash
sudo apt install rclone
```



### OVH Config

Once your OpenStack user account has been created, you can retrieve the config file you need for Rclone from your Control Panel.

To do this, when you are on the OpenStack user page in your Control Panel, click the wrench symbol on the right, then on `Download an Rclone config file`.

![](https://docs.ovh.com/cz/cs/storage/sync-rclone-object-storage/images/download_file.png)

Once the file has been downloaded, run following command to setup

```bash
rclone --config <file_path>
```





**Alternative manual config**

Once the file has been downloaded, copy everything from it and run following command to create `rclone.conf` file and paste.

```bash
sudo nano /home/$USER/.config/rclone/rclone.conf
```

```rclone.conf
[ovh]
type = swift
env_auth = false
auth_version = 3
auth = https://auth.cloud.ovh.net/v3/
endpoint_type = public
tenant_domain = default
tenant = 206912604105343434
domain = default
user = <USER>
key = <PASSWORD>
region = DE
```

you can launch the following command to add your new storage space:

```bash
rclone config
```

You can find more detailed instructions on how to synchronise your object storage and Rclone on the official Rclone website: [Official Rclone documentation](https://rclone.org/swift/).



### Mount

```bash
sudo rclone mount ovh:naim/ /var/www/ovh --allow-other
```

with buffer

```bash
sudo rclone mount ovh:naim/ /var/www/ovh --allow-other --buffer-size 150M --max-read-ahead 100M --dir-cache-time 150m0s
```



### Auto Mount on Start

Create folder to Mount

```
sudo mkdir /mnt/ovh
sudo chown -R $USER:$USER /mnt/ovh
sudo chmod 777 /mnt/ovh
```

To enable auto start, we can create a systemd service.

```bash
sudo nano /etc/systemd/system/ovh.service
```

Put the following text into the file.

```reStructuredText
[Unit]
Description=OVH Mount
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
ExecStart=/usr/bin/rclone mount \
--allow-other \
--max-read-ahead=100M \
ovh:naim/ /mnt/ovh
ExecStop=/bin/fusermount -u /mnt/ovh
Restart=always
SyslogIdentifier=OVH Mount

[Install]
WantedBy=multi-user.target
```



Save and close the file. Then reload systemd.

```bash
sudo systemctl daemon-reload
```

Next, Stop

```
sudo pkill ovh && sudo systemctl stop ovh
```

Use the systemd service to start.

```
sudo systemctl start ovh
```

Enable auto start at boot time.

```
sudo systemctl enable ovh
```

Now check satus.

```
systemctl status ovh
```



### Unmount

```bash
sudo fusermount -u /var/www/ovh
```



### Check mounted disk

```bash
df -h
```



### List

List all the objects in the path with size, modification time and path.

```bash
lsl ovh:naim/movies/
```

List all directories/containers/buckets in the path.

```
rclone lsd remote:path
```

List all the objects in the path with size and path.

```
rclone ls BackupStorage:naim/movie/
```



### Copy file

```bash
rclone copy /local/path ovh:naim
```



### Docs

https://rclone.org/docs/
