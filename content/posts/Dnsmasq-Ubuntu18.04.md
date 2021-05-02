+++
title = 'Dnsmasq on Ubuntu'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2018-03-24
description = 'How to setup dnsmasq on ubuntu'
categories = ["dnsmasq","ubuntu"]
type = 'post'
+++


Dnsmasq is a very lightweight local DNS server. dnsmasq can also be configured as a DNS cache server and DHCP server. dnsmasq has IPv4 and IPv6 supports including DHCPv4 and DHCPv6. dnsmasq is ideal for small network. In this guide, I am going to show you how to use dnsmasq to configure a local DNS server, caching DNS server and DHCP server. So, let’s get started.

Table of Contents
=================

* [Network Topology](#network-topology)
* [Installing](#installing)
* [Configuration](#configuration)
* [Adding DNS records to Dnsmasq](#adding-dns-records-to-dnsmasq)
* [Configuring nameservers](#configuring-nameservers)
* [Testing Dnsmasq](#testing-dnsmasq)
* [Troubleshoot](#troubleshoot)

### Network Topology

I will configure a Ubuntu box as a DNS server by dnsmasq service. It has a network interfaces, connects to a home network swtich. All the other hosts on the network will be use this Ubuntu box as DNS server for name resolution.

Ubuntu box Static IP: `192.168.0.101/24`



### Installing

Ubuntu 18.04 comes with systemd-resolve which you need to disable since it binds to port **53** which will conflict with Dnsmasq port.

Run the following commands to disable the resolved service:

```bash
sudo systemctl disable systemd-resolved && \
sudo systemctl stop systemd-resolved
```

Also, remove the symlinked `resolv.conf` file. Then create new **resolv.conf** file:

```bash
sudo rm /etc/resolv.conf && \
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

Dnsmasq is available on the apt repository, easy installation can be done by running:

```bash
sudo apt install -y dnsmasq
```



### Configuration

The main configuration file for Dnsmasq is `/etc/dnsmasq.conf`. Configure Dnsmasq by modifying this file.

```bash
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.original && \
sudo rm -f /etc/dnsmasq.conf && \
sudo nano /etc/dnsmasq.conf
```

Copy and paste configuration:

```
# Listen on this specific port instead of the standard DNS port
# (53). Setting this to zero completely disables DNS function,
# leaving only DHCP and/or TFTP.
port=53

# Never forward plain names (without a dot or domain part)
domain-needed

# Never forward addresses in the non-routed address spaces.
bogus-priv

# By  default,  dnsmasq  will  send queries to any of the upstream
# servers it knows about and tries to favour servers to are  known
# to  be  up.  Uncommenting this forces dnsmasq to try each query
# with  each  server  strictly  in  the  order  they   appear   in
# /etc/resolv.conf
strict-order
```

Restart dnsmasq when done:

```bash
sudo systemctl restart dnsmasq && \
sudo systemctl status dnsmasq
```

Now, you have to set `127.0.0.1`  as primary and `8.8.8.8` secondary DNS server in the `/etc/resolv.conf`.

```bash
sudo rm -f /etc/resolv.conf && \
echo "nameserver 127.0.0.1\nnameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```



### Adding DNS records to Dnsmasq

Add DNS records in the file.`/etc/hosts`. Dnsmasq will reply to queries from clients using these records.

```bash
sudo nano /etc/hosts
```

```
192.168.0.1 router.home.com
192.168.0.101 dns.home.com
192.168.0.100 hsrv.home.com
192.168.0.102 pihole.home.com
```

You need to restart dnsmasq service after adding the records.

```bash
sudo systemctl restart dnsmasq
```



### Configuring nameservers

Set dnsmasq server IP as dafault nameservers by reconfigure network interface:

```bash
sudo nano /etc/netplan/*.yaml
```

```yaml
network:
  ethernets:
    ens3:
      addresses:
      - 192.168.0.101/24
      gateway4: 192.168.0.1
      nameservers:
        addresses:
        - 192.168.0.101 # Set your dnsmasq server IP
  version: 2
```

Before we apply the change, let’s test the configuration:

```bash
sudo netplan try
```

The above command will validate the configuration before applying it. If it succeeds, you will see Configuration accepted. In other words, Netplan will attempt to apply the new settings to a running system. Should the new configuration file fail, Netplan will automatically revert to the previous working configuration. Should the new configuration work, it will be applied.

If you are certain of your configuration file, you can skip the try option and go directly to applying the new options. The command for this is:

```bash
sudo netplan apply
```



### Testing Dnsmasq

To verify that Dnsmasq responds, using dig:

```bash
dig router.home.com
```

Output:

```
; <<>> DiG 9.11.3-1ubuntu1.13-Ubuntu <<>> router.home.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23483
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;router.home.com.               IN      A

;; ANSWER SECTION:
router.home.com.        0       IN      A       192.168.0.1

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Mon Dec 21 22:42:08 UTC 2020
;; MSG SIZE  rcvd: 60
```



### Troubleshoot

Sometimes you could face difficulty to start the Dnsmasq service. Because of the Dnsmasq background process. To fix this issue, follow the step: 

```bash
sudo ss -lp "sport = :domain" | grep pid
```

Output:

```
❯ sudo ss -lp "sport = :domain"
Netid    State      Recv-Q     Send-Q                                    Local Address:Port           Peer Address:Port
udp      UNCONN     0          0                                             127.0.0.1:domain              0.0.0.0:*        users:(("dnsmasq",pid=2438,fd=6))
udp      UNCONN     0          0                                         192.168.0.101:domain              0.0.0.0:*        users:(("dnsmasq",pid=2438,fd=4))
udp      UNCONN     0          0                                                 [::1]:domain                 [::]:*        users:(("dnsmasq",pid=2438,fd=14))
```

Now kill pid=2438

```bash
sudo kill 2438
```

And restart dnsmasq

```bash
sudo systemctl restart dnsmasq
```

