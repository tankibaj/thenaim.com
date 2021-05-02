+++
title = 'Setting up Swap Memory'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2018-02-23
description = 'Setting up Swap Memory'
categories = ["swap","ubuntu"]
type = 'post'
+++

A swap file allows Linux to simulate the disk space as RAM. When your system starts running out of RAM, it uses the swap space to and swaps some content of the RAM on to the disk space.


From Ubuntu 18.04 onwards, a swapfile rather than a dedicated swap partition is used. The swap file is named `swapfile`.

To change the size of this swap file:

- Disable the swap file and delete it (not really needed as you will overwrite it)

```bash
sudo swapoff /swapfile
sudo rm /swapfile
```


- Create a new swap file of the desired size.
Determine the size of your swap file. If you want to make a 4 GB swap file, you will need to write 4 * 1024 blocks of 10242 bytes (= 1 MiB). That will make your count equal to 4 * 1024 = 4096. Create the file of this size with the command:

```bash
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
```


- Assign it read/write permissions for root only (not strictly needed, but it tightens security)

```bash
sudo chmod 600 /swapfile
```

- Format the file as swap:

```bash
sudo mkswap /swapfile
```

- The file will be activated on the next reboot. If you want to activate it for the current session:

```bash
sudo swapon /swapfile
```
- You can check the swap that is available with the command: (no root permissions needed)

```bash
swapon -s
```
