+++
title = 'Bash Alias - Make Life Easier'
image = '/images/post/bash.png'
author = 'Naim'
date = 2017-02-02
description = 'Bash Alias - Make Life Easier'
categories = ["alias","bash"]
type = 'post'
+++


A Bash alias is a method of supplementing or overriding Bash commands with new ones. Bash aliases make it easy for users to customize their experience in a POSIX terminal. They are often defined in `$HOME/.bashrc` or `$HOME/bash_aliases` (which must be loaded by `$HOME/.bashrc`).


###### Example: Setting up an alias for the – sudo apt-get install – command

- Open the .bashrc file located in your home folder.

```bash
sudo nano ~/.bashrc
```

- Move to the end of the file and paste the following line:

```bash
alias install='sudo apt-get install'
```
Save the file by ctrl+x.

Here `install` is the new alias we are setting up.


```bash
source ~/.bashrc
```


###### Example aliases for git

```text
alias nah='git reset --hard && git clean -df'

alias gs='git status'

alias gl='git log'

alias ga='git add .'

alias gc='git commit -m'

alias gp='git push'

alias gpm='git push -u origin master'

alias ps='/usr/local/bin/pstorm'

alias open='gnome-open'
```
