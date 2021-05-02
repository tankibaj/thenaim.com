+++
title = 'How to create Sudo user on Ubuntu'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2016-02-01
description = 'Setting up Sudo User on Ubuntu'
categories = ["sudo","ubuntu"]
type = 'post'
+++

sudo is a program for Unix-like computer operating systems that allows users to run programs with the security privileges of another user, by default the superuser.


Use the adduser command to add a new user to your system.

```shell
adduser username
```

Set and confirm the new user’s password at the prompt. A strong password is highly recommended!
```shell
# Enter new UNIX password:
# Retype new UNIX password:
# passwd: password updated successfully
```

Follow the prompts to set the new user’s information. It is fine to accept the defaults to leave all of this information blank.
```shell
# Changing the user information for username
# Enter the new value, or press ENTER for the default
#     Full Name []:
#     Room Number []:
#     Work Phone []:
#     Home Phone []:
#     Other []:
# Is the information correct? [Y/n]
```

Use the usermod command to add the user to the sudo group. By default, on Ubuntu, members of the sudo group have sudo privileges.
```shell
usermod -aG sudo username
```

Test sudo access on new user account
```shell
su - username
```

As the new user, verify that you can use sudo by prepending “sudo” to the command that you want to run with superuser privileges.
```shell
sudo apt update
```

If your user is in the proper group and you entered the password correctly, the command that you issued with sudo should run with root privileges.
