+++
title = 'Essential Git Command'
image = '/images/post/git.png'
author = 'Naim'
date = 2018-08-18
description = 'Essential Git Command'
categories = ["git"]
type = 'post'
+++


Git is a distributed version-control system for tracking changes in source code during software development.

Table of Contents
=================

* [Concepts Of Git](#concepts-of-git)
* [Basic Commands](#basic-commands)
* [Installing Git](#installing-git)
* [Git Ignore](#git-ignore)
* [Global ignored files for all repositories on your computer](#global-ignored-files-for-all-repositories-on-your-computer)
* [Excluding local files without creating a <em>\.gitignore</em> file](#excluding-local-files-without-creating-a-gitignore-file)
* [Generating a new SSH key and adding it to the ssh\-agent](#generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* [Connect Git account from fresh PC through SSH key](#connect-git-account-from-fresh-pc-through-ssh-key)
* [Create a new repository on the command line](#create-a-new-repository-on-the-command-line)
* [Git branch](#git-branch)
* [Change Git Commit Message, Even After Push](#change-git-commit-message-even-after-push)
* [Git Reset and Clean (Restore to last commit)](#git-reset-and-clean-restore-to-last-commit)
* [Git Alias](#git-alias)
------------

### Concepts Of Git

- Keeps tarack of code history
- Takes "snapshots" of your file
- You decide when to take a snapshots by making a "commit"
- You can visit any snapshot at any time
- You can stage files before commit


### Basic Commands

```git init``` 					Initailze local Git repository

```git add <file>``` 			Add/Track file(s) to index

```git add *.html``` 			Add/Track only html extension file(s) to index

```git add .``` 				Add/Track all type of file(s) to index

```git rm --cached <file>``` 	Remove/Untracked file(s) from index

```git rm -r -f --cached <directory>``` Force remove/untracked directory from index

```git status``` 				Check status of working text

```git config --global user.name 'My Name'``` Add name

```git config --global user.email 'email@example.com'``` Add Email

```git commit``` 				Commit changes in index

```git commit -m '<msg>'``` Commit changes in index with message

```git push``` 					Push to remote respository

```git pull``` 					Pull latest from remote respository

```git clone``` 				Clone respository into a new directory

```git log``` 				To see commited logs



### Installing Git

- Linux (Debian)
```
sudo apt-get install git
```

- Linux (Fedora)
```
sudo yum install git
```

- Mac

```<link>``` : <https://git-scm.com/download/mac>

- Windows

```<link>``` : <https://git-scm.com/download/win>



### Git Ignore

You can configure Git to ignore files you don't want to check in to GitHub. You can create a *.gitignore* file in your repository's root directory to tell Git which files and directories to ignore when you make a commit. To share the ignore rules with other users who clone the repository, commit the *.gitignore* file in to your repository.

A gitignore file specifies intentionally untracked files that Git should ignore. Patterns read from a .gitignore file in the same directory as the path. Each line in a gitignore file specifies a pattern.

GitHub maintains an official list of recommended *.gitignore* files for many popular operating systems, environments, and languages in the `github/gitignore` public repository. You can also use gitignore.io to create a *.gitignore* file for your operating system, programming language, or IDE. For more information, see "[github/gitignore](https://github.com/github/gitignore)" and the "[gitignore.io](https://www.gitignore.io/)" site.



Create .gitignore file** `touch .gitignore`

.gitignore file writing pattern format

`*.html` ignore all html files

`log.txt` ignore 'log.txt' file

`/mydir` ignore 'mydir' directory

`.idea/*`



### Global ignored files for all repositories on your computer

You can also create a global *.gitignore* file to define a list of rules for ignoring files in every Git repository on your computer. For example, you might create the file at *~/.gitignore_global* and add some rules to it.

1. Open Terminal.

2. Configure Git to use the exclude file `~/.gitignore_global` for all Git repositories. Use [gitignore.io](https://www.gitignore.io/) if needed.

   ```
   git config --global core.excludesfile ~/.gitignore_global
   ```



### Excluding local files without creating a *.gitignore* file

If you don't want to create a *.gitignore* file to share with others, you can create rules that are not committed with the repository. You can use this technique for locally-generated files that you don't expect other users to generate, such as files created by your editor.

Use your favorite text editor to open the file called *.git/info/exclude* within the root of your Git repository. Any rule you add here will not be checked in, and will only ignore files for your local repository.

1. Open Terminal.
2. Navigate to the location of your Git repository.
3. Using your favorite text editor, open the file `.git/info/exclude`




### Generating a new SSH key and adding it to the ssh-agent

- Open Git Bash.
- Paste the text below, substituting in your GitHub email address.

`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`

- When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location (C:/Users/you/.ssh/id_rsa)

Adding your SSH key to the ssh-agent. Before adding a new SSH key to the ssh-agent to manage your keys, you should have checked for existing SSH keys and generated a new SSH key.

If you have GitHub Desktop installed, you can use it to clone repositories and not deal with SSH keys. It also comes with the Git Bash tool, which is the preferred way of running git commands on Windows.

- Ensure the ssh-agent is running
```
eval $(ssh-agent -s)
```
> Agent pid 59566 //result

- Add your SSH private key to the ssh-agent. If you created your key with a different name, or if you are adding an existing key that has a different name, replace id_rsa in the command with the name of your private key file.

```
ssh-add ~/.ssh/id_rsa
```



### Connect Git account from fresh PC through SSH key

- Put existing ssh private cd on `~/.ssh` folder.

- Ensure the ssh-agent is running

```
eval $(ssh-agent -s)
```

- Add your SSH private key to the ssh-agent.

```
ssh-add ~/.ssh/id_rsa
```

- Test git ssh connection

```
ssh -T git@github.com
```



### Create a new repository on the command line

```
git init
echo ".gitignore" >> .gitignore
git add .
git commit -m "first commit"
git remote add origin git@github.com:GitUsername/repositoryname.git
git push -u origin master
```



### Git branch

Git, branches are a part of your everyday development process. Git branches are effectively a pointer to a snapshot of your changes.

- Create a branch

```
git branch <name>
```

- Switch branch

```
git checkout <name>
```

- Merge file(s) with master

```
git merge <BranchName> -m '<msg>'
```



### Change Git Commit Message, Even After Push

```
git log

git commit --amend

git rebase -i HEAD~2

git push -f

git log --oneline
```



### Git Reset and Clean (Restore to last commit)

```
git reset --hard;git clean -df;
```
Or

```
git reset --hard && git clean -df
```



### Git Alias

```text
alias nah='git reset --hard && git clean -df'

alias gs='git status'

alias gl='git log'

alias ga='git add .'

alias gc='git commit -m'

alias gp='git push'

alias gpm='git push -u origin master'
```
