+++
title = 'Count Lines of Code - cloc'
image = '/images/post/macos.png'
author = 'Naim'
date = 2019-11-14
description = 'Setting up Count Lines of Code - cloc'
categories = ["cloc","macos"]
type = 'post'
+++


`Count Lines of Code - (cloc)` counts blank lines, comment lines, and physical lines of source code in many programming languages. cloc is now being developed at https://github.com/AlDanial/cloc


Table of Contents
=================

* [Quick Start](#quick-start)
* [Basic Use](#basic-use)
  * [Exclude Multiple Directories](#exclude-multiple-directories)
  * [Exclude File Extensions](#exclude-file-extensions)
  * [Exclude List File](#exclude-list-file)
  * [Exclude List File and Extensions](#exclude-list-file-and-extensions)


## Quick Start


Install on Mac:

```bash
brew install cloc
```

## Basic Use



cloc is a command line program that takes file, directory, and/or archive names as inputs. Here's some examples of running cloc:


#### Exclude Multiple Directories

Exclude the given comma separated directories D1, D2, D3, et cetera, from being scanned. For example  --exclude-dir=.vendor,upload  will skip all files and subdirectories that have /vendor/ or /upload/ as their parent directory.

```bash
cloc --exclude-dir=vendor,upload .
```


#### Exclude File Extensions

Do not count files having the given file name extensions.

```bash
cloc --exclude-ext=css,html .
```


#### Exclude List File

Ignore files and/or directories whose names appear in <file>.  <file> should have one file name per line.  Only exact matches are ignored; relative path names will be resolved starting from the directory where cloc is invoked. See also --list-file.

```bash
cloc --exclude-list-file=.clocignore .
```



We name ignore file name `.clocignore`

```text
vendor
logs
public/uploads
public/assets/css
public/assets/img
public/assets/fontawesome
public/assets/plugins/jquery
README.md
```


#### Exclude List File and Extensions

Ignore count files and/or directories whose names appear in `.clocignore`  and file extensions.

```bash
cloc --exclude-ext=md,css,html --exclude-list-file=.clocignore .
```



`.clocignore` file

```bash
vendor
logs
public/uploads
public/assets/css
public/assets/img
public/assets/fontawesome
public/assets/plugins/jquery
README.md
```

