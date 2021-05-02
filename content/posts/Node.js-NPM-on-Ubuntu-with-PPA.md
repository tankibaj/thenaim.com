+++
title = 'Nodejs on Ubuntu'
image = '/images/post/nodejs.png'
author = 'Naim'
date = 2018-11-09
description = 'Setting up Nodejs on Ubuntu'
categories = ["nodejs","ubuntu"]
type = 'post'
+++



Node.js is a platform built on Chrome’s JavaScript runtime for easily building fast, scalable network applications. Latest version node.js ppa is maintaining by its official website. We can add this PPA to your Ubuntu 19.04, 18.04 LTS, 16.04 LTS (Trusty Tahr) and 14.04 LTS (Xenial Xerus) systems and install node.js on Linux VPS with easy commands.

Node.js package is available in LTS release and the current release. It’s your choice to select which version you want to install on the system as per your requirements. Let’s add the PPA to your system to install Nodejs on Ubuntu.


Table of Contents
=================

* [Current Release](#current-release)
* [Use LTS Release](#use-lts-release)
* [Nodejs installation](#nodejs-installation)
* [Check version](#check-version)



### Current Release
```shell
sudo apt-get install curl
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
```

### Use LTS Release

```shell
sudo apt-get install curl
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
```

### Nodejs installation
You can successfully add Node.js PPA to Ubuntu system. Now execute the below command install Node on and Ubuntu using apt-get. This will also install NPM with node.js. This command also installs many other dependent packages on your system.

```shell
sudo apt-get install nodejs
```

### Check version

Check the installed version.

```shell
node -v
```

Check the npm version

```shell
npm -v
```
