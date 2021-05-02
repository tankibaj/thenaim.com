+++
title = 'Increase SSH Security'
image = '/images/post/ssh.png'
author = 'Naim'
date = 2018-04-25
description = 'Increase SSH Security'
categories = ["ssh"]
type = 'post'
+++


SSH or Secure Shell is a cryptographic network protocol for operating network services securely over an unsecured network.


First, you need to configure SSH keys for login. Once you have SSH Keys configured, you need to disable password login for all users include root.



### Disable root login and password based login



Edit the /etc/ssh/sshd_config file, enter:

```bash
sudo nano /etc/ssh/sshd_config
```



Do following changes:

```text
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin no
```



Save and close the file. Reload the ssh server:

```bash
sudo systemctl reload ssh
```



### Verification

Try to login as root:

```bash
ssh root@192.168.1.100

#Permission denied (publickey)
```



Try to login with password only:

```bash
ssh user@192.168.1.100 -o PubkeyAuthentication=no

#Permission denied (publickey)
```

