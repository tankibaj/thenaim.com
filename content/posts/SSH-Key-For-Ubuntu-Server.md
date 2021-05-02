+++
title = 'SSH Key For Ubuntu Server'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2017-12-15
description = 'Setting up '
categories = ["ssh","ubuntu"]
type = 'post'
+++

SSH or Secure Shell is a cryptographic network protocol for operating network services securely over an unsecured network.


### Generate SSH Key

Run following command on your `local pc` terminal. 

```bash
ssh-keygen -t rsa -b 4096 -C 'mail@thenaim.com'
```



### Create a New Sudo User

Run following command on your `ubuntu server` terminal

```bash
adduser naim
```



Set and confirm the new user’s password at the prompt. A strong password is highly recommended!

```bash
# Enter new UNIX password:
# Retype new UNIX password:
# passwd: password updated successfully
```



Follow the prompts to set the new user’s information. It is fine to accept the defaults to leave all of this information blank.

```bash
# Changing the user information for username
# Enter the new value, or press ENTER for the default
#     Full Name []:
#     Room Number []:
#     Work Phone []:
#     Home Phone []:
#     Other []:
# Is the information correct? [Y/n]
```



Use the usermod command to add the user to the sudo group. By default, on Ubuntu, members of the `sudo group` have `sudo` privileges.

```bash
usermod -aG sudo username
```



Test sudo access on new user account

```
su - naim
```



As the new user, verify that you can use sudo by prepending `sudo` to the command that you want to run with superuser privileges. If your user is in the proper group and you entered the password correctly, the command that you issued with sudo should run with root privileges.

```bash
sudo apt update
```



### Setup SSH Key On Server



Run following command on your `ubuntu server` terminal to copy `id_rsa.pub` key

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```



Now lets create an `authorized_keys` file using nano and paste the `id_rsa.pub`. It should be located in `~/ssh/`. Run following command on your `ubuntu server` terminal.

```bash
sudo mkdir ~/.ssh && sudo chown -R $USER /home/$USER/
sudo nano ~/.ssh/authorized_keys
sudo chmod 700 ~/.ssh/ && sudo chmod 600 ~/.ssh/authorized_keys
```



Now, you have to restrict `root` user login permit and login using password. To do that open ssh configuration file.

```bash
sudo nano /etc/ssh/sshd_config

```

And change following

```
PasswordAuthentication no
PermitRootLogin no
```



Now as we have made changes in ssh configuration we have to `restart ssh service` for our `ubuntu server`.

```bash
sudo systemctl restart ssh
```

