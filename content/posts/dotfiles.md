+++
title = 'dotfiles'
image = '/images/post/macos.png'
author = 'Naim'
date = 2021-02-27
description = ''
categories = ["dotfiles","macos","ubuntu"]
type = 'post'
+++



I have been using bash since 2005. In all that time, whenever I set up a new macOS or Linux machine, I had to copy over my `.bashrc` file to each machine manually. It was a real mess.

Last year, I decided to execute a single command on a new system to pull down all of my dotfiles and install all the tools I commonly use. That’s why I have created two dotfiles Github repositories. One for macOS and the other for Ubuntu and Debian. It helps me to install everything automatically.


## macOS

#### Prerequisite

- [xCode](https://developer.apple.com/downloads/index.action?=xcode). The easiest way to install xCode is the command line. Type `xcode-select --install` on terminal.


#### Install dotfiles

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tankibaj/dotfiles/main/install.sh)"
```


## Ubuntu | Debian

#### Install dotfiles

###### wget

```bash
bash -c "$(wget -O- -q https://raw.githubusercontent.com/tankibaj/dotfiles-ubuntu/main/install.sh)"
```

###### curl

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tankibaj/dotfiles-ubuntu/main/install.sh)"
```


