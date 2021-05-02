+++
title = 'Disable IPv6'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2018-02-03
description = ''
categories = ["ipv6", "ubuntu"]
type = 'post'
+++

In this article I will show how to disable IPv6 on Ubuntu.

Table of Contents
=================

* [Method 1 \- Disable IPv6 using GRUB](#method-1---disable-ipv6-using-grub)
* [Method 2 \- Disable IPv6 using Sysctl](#method-2---disable-ipv6-using-sysctl)
* [Re\-enable IPv6](#re-enable-ipv6)


#### Method 1 - Disable IPv6 using GRUB

Configure `GRUB` to pass kernel parameters at boot time. You’ll have to edit `/etc/default/grub`. Once again, make sure you have administrator privileges:

```bash
sudo nano /etc/default/grub
```

Now you need to modify `GRUB_CMDLINE_LINUX_DEFAULT` and `GRUB_CMDLINE_LINUX` to disable IPv6 on boot:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"
GRUB_CMDLINE_LINUX="ipv6.disable=1"
```

Save the file and run the `update-grub` command:

```bash
sudo update-grub
```

The settings should now persist on reboot.





#### Method 2 - Disable IPv6 using Sysctl

This only `temporarily disables IPv6`. The next time your system boots, IPv6 will be enabled again.

To use this method run following command on terminal

```bash
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
```



However, If you put a little effort you can make this method as **permanently disables IPv6**. To do that, you to modify `/etc/sysctl.conf`.

```bash
sudo nano /etc/sysctl.conf
```

Add the following lines to the file (ignore it, if already exist those line):

```bash
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
```

For the settings to take effect use:

```bash
sudo sysctl -p
```

Now, create (with root privileges) the file **/etc/rc.local** 

```bash
sudo nano /etc/rc.local
```

And fill it with the following lines:

```
#!/bin/bash
# /etc/rc.local

/etc/sysctl.d
/etc/init.d/procps restart

exit 0
```

Now use chmod command to make the file executable:

```bash
sudo chmod 755 /etc/rc.local
```

What this will do is manually read (during the boot time) the kernel parameters from your sysctl configuration file.





#### Re-enable IPv6

If you modified the kernel parameters in **/etc/default/grub**, go ahead and delete the added options:

```
sudo nano /etc/default/grub
```

Now you need to modify `GRUB_CMDLINE_LINUX_DEFAULT` and `GRUB_CMDLINE_LINUX` to re-enable IPv6 on boot:

```grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
```

Now do:

```
sudo update-grub
```


If you modified `/etc/sysctl.conf` you can either remove the lines you added or change them to:

```conf
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=0
net.ipv6.conf.lo.disable_ipv6=0
```

You can optionally reload these values:

```
sudo sysctl -p
```

you can remove `/etc/rc.local`:

```
sudo rm /etc/rc.local
```

