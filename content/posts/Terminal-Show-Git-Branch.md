+++
title = 'Show Git Branch In Terminal'
image = '/images/post/git.png'
author = 'Naim'
date = 2017-02-05
description = ''
categories = ["git"]
type = 'post'
+++


Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Git is easy to learn and has a tiny footprint with lightning fast performance.


To display the current prompt setting, run:

```shell
echo $PS1
```

Sample output:

```test
[\u@\h \W]$
```

Open the ~/.bashrc file with your favorite text editor and add the following lines:

```shell
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="[\u@\h \W]\$(git_branch)\$ "
```
The git_branch() is a function, that prints the name of the current Git branch in the round brackets.
We set the PS1 variable and place the function git_branch() inside it to display the Git branch in the terminal prompt.

The function inside the PS1 variable must be in the following format: \$(git_branch).

Load the ~/.bashrc to apply changes for the current session without login/logout:

```shell
source ~/.bashrc
```

To prettify your command prompt you can colorize:

Without Host

```shell
export PS1="\[\033[38;5;35m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;184m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;31m\]\$(git_branch)\[$(tput sgr0)\]\[\e[1m\]:: \[$(tput sgr0)\]"
```

With Host

```bash
export PS1="\[\033[38;5;35m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;35m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;184m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;31m\]\$(git_branch)\[$(tput sgr0)\]\[\e[1m\]:: \[$(tput sgr0)\]"
```


You can generate your .bashrc/PS1 bash prompt easily -> [http://bashrcgenerator.com/](http://bashrcgenerator.com/)

 
