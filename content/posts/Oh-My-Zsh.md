+++
title = 'Oh My Zsh'
image = '/images/post/ohmyzsh.png'
author = 'Naim'
date = 2019-08-28
description = 'Setting up Oh My Zsh'
categories = ["ohmyzsh","zsh"]
type = 'post'
+++


Oh My Zsh is an open source, community-driven framework for managing your [zsh](https://www.zsh.org/) configuration. It will not make you a 10x developer…but you might feel like one”


Table of Contents
=================

* [ZSH](#zsh)
* [Alias](#alias)
* [Theme](#theme)
    * [PowerLeve10K](#powerleve10k)
    * [Robbyrussell](#robbyrussell)


#### Oh-My-Zsh

It runs on Zsh to provide cool features configurable within the ~/.zhrc config file. Install [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) by running the command

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```



You can upgrade it to get the latest features it offers:

```bash
upgrade_oh_my_zsh
```


#### Alias

Modify .zshrc to add your custome aliases:

```bash
nano ~/.zshrc
```



Add followings at the end

```bash
##### My Config #####
# Basic For Mac OS
alias home="cd ~"
alias sites="cd ~/sites"
alias zshrc='open -a /Applications/Sublime\ Text.app ~/.zshrc'
alias sublime="open -a /Applications/Sublime\ Text.app"
alias phps='open -a PhpStorm ./'
alias sourczsh='source ~/.zshrc'

# Git Alias
alias g='git'
alias gi='git init'
alias ga='git add .'
alias gc='git commit -m'
alias gs='git status'
alias gl='git log'
alias gp='git push'
alias gpm='git push -u origin master'
alias nah='git reset --hard && git clean -df'
alias gb='git branch -a'
alias gco='git checkout'
alias gnb='git checkout -b'
alias gdb='git branch -D'
alias gsr='git remote set-url origin'
```



Set the zsh theme and update your changes

```bash
source ~/.zhrc
```



#### Theme

##### PowerLeve10K



We will clone the repository into the custom theme folder

```bash
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```



Download and install [**FuraMono Nerd Font**](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fura Mono Regular Nerd Font Complete.otf?raw=true)**.** It’s best and works everywhere. For linux (Ubuntu) you will need the [**FiraMono**](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fira Mono Regular Nerd Font Complete.otf?raw=true) otherwise your terminal may not show up the font.

You can get all the [**FuraMono fonts**](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraMono)



Download Plugins for autosuggestion and syntax highlighting:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions && /
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```



Now edit your `~/.zshrc` file to use the **PowerLeve10K** **theme**, **Awesome Patched font, Autocorrection, Autosuggestion** and **Syntax highlighting.**

```bash
nano ~/.zshrc
```



Find the `ZSH_THME` and replace it with

```
ZSH_THEME="powerlevel10k/powerlevel10k"
```



Also add this line below to use [Nerd Patched fonts](https://github.com/ryanoasis/nerd-fonts)

```
POWERLEVEL9K_MODE="nerdfont-complete"
```



If you want to enable auto correction then find uncomment the line by removing `#` from

```
ENABLE_CORRECTION="true"
```



Now we will add plugins so scroll down a little till you find

```
plugins=(git)
```



And now add the plugins which we downloaded, like this

```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```



##### Robbyrussell

Modify robbyrussell theme to add git branch

```bash
nano ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
```



Paste followings:

```
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info) %{$fg[yellow]%}:: %{$reset_color%} %{$fg[white]%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
```