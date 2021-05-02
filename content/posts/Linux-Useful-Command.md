+++
title = 'Linux Useful Command'
image = '/images/post/linux.png'
author = 'Naim'
date = 2016-12-23
description = 'Most useful command for linux'
categories = ["linux","ubuntu"]
type = 'post'
+++


Most useful command for linux.


Table of Contents
=================

* [Find Out IP Address](#find-out-ip-address)
* [Find Out Default Gateway](#find-out-default-gateway)
* [Find Out DNS | Nanme Server](#find-out-dns--nanme-server)
* [Find Out Public IPv6](#find-out-public-ipv6)
* [Directories listing with their total sizes](#directories-listing-with-their-total-sizes)
* [Show network interfaces](#show-network-interfaces)
* [Show network interfaces with ip](#show-network-interfaces-with-ip)
* [Check the linux kernel version](#check-the-linux-kernel-version)
* [Check free disk space](#check-free-disk-space)
* [Check open port in linux](#check-open-port-in-linux)
* [Check CPU process](#check-cpu-process)
* [Look up something don't know](#look-up-something-dont-know)


##### Find Out IP Address

```bash
ip a | grep inet
```

OR

```bash
ifconfig | grep inet
```



##### Find Out Default Gateway

```bash
route -n
```

OR

```bash
ip route show
```

OR

```bash
ip r
```



##### Find Out DNS | Nanme Server

```bash
systemd-resolve --status | grep DNS
```

OR

```bash
cat /run/systemd/resolve/resolv.conf
```

OR

```bash
systemd-resolve --status
```



##### Find Out Public IPv6

```bash
curl -s ipv6.icanhazip.com | xargs echo -n
```



##### Directories listing with their total sizes

```bash
du -sh *
```

short version of:

```bash
du --summarize --human-readable *
```


##### Show network interfaces

```bash
netstat -i
```


##### Show network interfaces with ip

```bash
arp -n
```


##### Check the linux kernel version

```bash
uname -a
```



##### Check free disk space

```bash
df -ah
```



##### Check open port in linux

```bash
netstat -tupln
```



##### Check CPU process

```bash
ps aux
```

OR

```bash
ps aux | grep nginx
```

OR

```bash
top
```

OR

```bash
htop
```



##### Look up something don't know

```bash
man <command>
```

```bash
man ps
```

