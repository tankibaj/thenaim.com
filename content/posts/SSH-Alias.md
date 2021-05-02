+++
title = 'SSH Alias'
image = '/images/post/ssh.png'
author = 'Naim'
date = 2020-08-20
description = 'Setting up SSH Alias'
categories = ["ssh"]
type = 'post'
+++


You can create SSH alias to frequently-accessed systems via SSH. This way you need not to remember all the different usernames, hostnames, ssh port numbers and IP addresses etc. Additionally, It avoids the need to repetitively type the same username/hostname, ip address, port no whenever you SSH into a Linux server(s).

Each user on your local system can maintain a client-side SSH configuration file. These can contain any options that you would use on the command line to specify connection parameters, allowing you to store your common connection items and process them automatically on connection. It is always possible to override the values defined in the configuration file at the time of the connection through normal flags to the ssh command.

The client-side configuration file is called config and it is located in your user's home directory within the .ssh configuration directory. Often, this file is not created by default, so you may need to create it yourself:

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```


##### Configuration File Structure

The config file is organized by hosts. Each host definition can define connection options for the specific matching host. Wildcards are also available to allow for options that should have a broader scope.

Each of the sections starts with a header defining the hosts that should match the configuration options that will follow. The specific configuration items for that matching host are then defined below. Only items that differ from the default values need to be specified, as the host will inherit the defaults for any undefined items. A section is defined from the Host header to the following Host header.

Typically, for organizational purposes and readability, the options being set for each host are indented. This is not a hard requirement, but a useful convention that allows for easier interpretation at a glance.

The general format will look something like this:

```text
Host home
    HostName example.com
    Port 4567 (Mension If port is not 22)
    User apollo


Host work
    HostName company.com
    Port 4567 (Mension If port is not 22)
    User apollo
```

##### Identity Configuration (Using Private Key)

The use of IdentityFile allows us to specify exactly which private key we wish to use for authentification with the given host.

```text
Host home
    HostName company.com
    Port 22 (optional)
    User apollo
    IdentityFile ~/.ssh/my.key
```
