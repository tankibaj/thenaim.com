+++
title = 'Yaru community theme on Ubuntu 18.04'
image = '/images/post/ubuntu.png'
author = 'Naim'
date = 2018-04-28
description = 'Setting up Yaru community theme on Ubuntu 18.04'
categories = ["ubuntu"]
type = 'post'
+++


Yaru is the GNOME Shell desktop theme for Ubuntu, backed by the community.

#### Install Communitheme
To install the Communitheme Snap package, use the command below:

```shell
sudo snap install communitheme
```

#### PPA
The [official Communitheme PPA](https://launchpad.net/~communitheme/+archive/ubuntu/ppa) is only available for Ubuntu 18.04. You CANNOT use this PPA in 16.04 or 17.10.

Open a terminal and use the following commands:

```shell
sudo add-apt-repository ppa:communitheme/ppa
sudo apt update
sudo apt install ubuntu-communitheme-session
```

#### Install Unity Tweak tool

```shell
sudo apt-get install unity-tweak-tool
```

## Change Theme
Once you have the Communitheme session installed, you can change the theme and icon using GNOME Tweaks. You’ll have to change the Applications theme to Communitheme and icons to Suru

![img](https://i.imgur.com/lEpmhNd.jpg)
