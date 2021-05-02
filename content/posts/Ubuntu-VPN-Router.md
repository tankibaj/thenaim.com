+++
title = 'OpneVPN Router on Ubuntu'
image = '/images/post/openvpn.png'
author = 'Naim'
date = 2018-07-23
description = 'Setting up OpneVPN Router on Ubuntu'
categories = ["openvpn","ubuntu"]
type = 'post'
+++


In computing, a [router on a stick](https://en.wikipedia.org/wiki/One-armed_router), also known as a one-armed router. It is a router that has a single physical or logical connection to a network. It is a method of inter-VLAN (virtual local area networks) routing where one router is connected to a switch via a single cable. The router has physical connections to the broadcast domains where one or more VLANs require the need for routing between them.


Setting up a Ubuntu box as an OpenVPN Gateway

### IP Address

My home network is set up as follows:

- Internet Router: `192.168.0.1/24`
- Ubuntu VPN Router IP: `192.168.0.101/24`



### NTP

Time accuracy is essential for VPN encryption. Install NTP package to synchronize the clocks of Ubuntu box over the internet.

```bash
sudo apt install ntp
```

Verify time:

```bash
ntpq -p
```



### VPN Client

Install OpenVPN client:

```bash
sudo apt install -y openvpn
```

Create auth file with credential that you have got from your VPN provider.

```bash
USER="username"
PASS="password"
sudo sh -c "echo '$USER\n$PASS' > /etc/openvpn/auth"
```

Verify auth file

```bash
sudo cat /etc/openvpn/auth
```

Change auth file permission so only root user can read it:

```bash
sudo chmod 600 /etc/openvpn/auth
```

Copy openvpn profile to openvpn client path:

```bash
sudo cp usa.ovpn /etc/openvpn/usa.conf
```

Append auth file to your openvpn profile:

```bash
sudo sed -i 's|auth-user-pass|auth-user-pass /etc/openvpn/auth|g' /etc/openvpn/usa.conf
```



### Test VPN

Run following command to test vpn:

```bash
sudo openvpn --config /etc/openvpn/usa.conf
```

If it works perfectly, then press `Ctrl+c` to exit and follow the next step.



### Connect vpn at system boot

Let's enable VPN connection on system boot:

```bash
sudo systemctl enable openvpn@usa
```



### Routing

```bash
echo -e '\n#Enable IP Routing\nnet.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf && \
sudo sysctl -p
```



### NAT

First, you need to verify your network interface name by running following command:

```bash
ifconfig -s
```

Now allow your local network traffic pass through in the VPN tunnel:

```bash
# Flush
  iptables -t nat -F
  iptables -t mangle -F
  iptables -F
  iptables -X

  # Block All
  iptables -P OUTPUT DROP
  iptables -P INPUT DROP
  iptables -P FORWARD DROP

  # Allow Localhost
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Make sure you can communicate with any DHCP server
  iptables -A OUTPUT -d 255.255.255.255 -j ACCEPT
  iptables -A INPUT -s 255.255.255.255 -j ACCEPT

  # Make sure that you can communicate within your own network
  iptables -A INPUT -s $ip_prefix -d $ip_prefix -j ACCEPT
  iptables -A OUTPUT -s $ip_prefix -d $ip_prefix -j ACCEPT

  # Allow established sessions to receive traffic:
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Allow TUN
  iptables -A INPUT -i tun+ -j ACCEPT
  iptables -A FORWARD -i tun+ -j ACCEPT
  iptables -A FORWARD -o tun+ -j ACCEPT
  iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE
  iptables -A OUTPUT -o tun+ -j ACCEPT

  # Allow DNS connection
  iptables -I OUTPUT 1 -p udp --dport 53 -m comment --comment "Allow DNS UDP" -j ACCEPT
  iptables -I OUTPUT 1 -p tcp --dport 53 -m comment --comment "Allow DNS TCP" -j ACCEPT

  # Allow NTP connection
  iptables -I OUTPUT 2 -p udp --dport 123 -m comment --comment "Allow NTP" -j ACCEPT

  # Allow VPN connection
  iptables -I OUTPUT 3 -p udp --dport 1194 -m comment --comment "Allow VPN" -j ACCEPT

  # Block All
  iptables -A OUTPUT -j DROP
  iptables -A INPUT -j DROP
  iptables -A FORWARD -j DROP

  # Log all dropped packages, debug only.
  iptables -N logging
  iptables -A INPUT -j logging
  iptables -A OUTPUT -j logging
  iptables -A logging -m limit --limit 2/min -j LOG --log-prefix "IPTables general: " --log-level 7
  iptables -A logging -j DROP
```

Iptables rules are by default not persistent after a reboot. To make iptables rules persistent after reboot, install following package:

```bash
sudo apt-get install -y iptables-persistent
```

The installer will ask if you want to save current Iptables rules. Select **Yes**. If you don't select yes, then run the following to save Iptables rules.

```bash
sudo netfilter-persistent save
```

Ensure that the netfilter-persistent will be enabled at boot

```bash
sudo systemctl enable netfilter-persistent
```



### Block Outbound Regular Traffic

Let's block outbound regular internet traffic. Only VPN tunnel traffic will be allowed. That means if the OpenVPN service goes down, the internet will stop working, rather than routing over regular internet.

```bash
sudo iptables -A OUTPUT -o tun0 -m comment --comment "vpn" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p icmp -m comment --comment "icmp" -j ACCEPT && \
sudo iptables -A OUTPUT -d 192.168.0.0/24 -o ens3 -m comment --comment "lan" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p udp -m udp --dport 1198 -m comment --comment "openvpn" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p tcp -m tcp --sport 22 -m comment --comment "ssh" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p udp -m udp --dport 123 -m comment --comment "ntp" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p udp -m udp --dport 53 -m comment --comment "dns" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -p tcp -m tcp --dport 53 -m comment --comment "dns" -j ACCEPT && \
sudo iptables -A OUTPUT -o ens3 -j DROP
```

Save Iptables rules.

```bash
sudo netfilter-persistent save
```


### Status and log

```bash
sudo systemctl status openvpn@usa
sudo journalctl -u openvpn@usa
```

