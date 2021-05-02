+++
title = "chmod - Linux Files and Folders Permission"
image = "/images/post/chmod.jpg"
author = "Naim"
date = 2017-04-01
description = "chmod - Linux Files and Folders Permission"
categories = ["linux", "ubuntu"]
type = "post"

+++

In Unix-like operating systems, the chmod command sets the permissions of files or directories.

Table of Contents
=================

* [Table of Contents](#table-of-contents)
    * [Basic](#basic)
    * [Permission numeric](#permission-numeric)
        * [Owner](#owner)
        * [Owner and Group](#owner-and-group)
        * [Owner, Group and Public](#owner-group-and-public)
        * [Others](#others)
    * [Batch permission change](#batch-permission-change)
    * [Links](#links)


### Basic

1 – can execute

2 – can write

4 – can read

The octal number is the sum of those free permissions, i.e.

3 (1+2) – can execute and write

6 (2+4) – can write and read



### Permission numeric

##### Owner

- `chmod 600` - Owner can `Read` and `Write`
- `chmod 700` - Owner can `Read`,  `Write` and `Execute`


##### Owner and Group

- `chmod 740` - Owner can `Read`,  `Write` and `Execute` | Group can `Read`

- `chmod 760` - Owner can `Read`,  `Write` and `Execute` | Group can `Read` and `Write`
- `chmod 770` - Owner can `Read`,  `Write` and `Execute` | Group can `Read`, `Write` and `Execute`



##### Owner, Group and Public

- `chmod 774` - Owner can `Read`,  `Write` and `Execute` | Group can `Read`, `Write` and `Execute` | Public can `Read`
- `chmod 776` - Owner can `Read`,  `Write` and `Execute` | Group can `Read`, `Write` and `Execute` | Public can `Read` and `Write`
- `chmod 777` - Owner can `Read`,  `Write` and `Execute` | Group can `Read`, `Write` and `Execute` | Public can `Read`, `Write` and `Execute`



##### Others

- `chmod 744` - Owner can `Read`,  `Write` and `Execute`  | Group can `Read` | Public can `Read`
- `chmod 666` - Owner can `Read` and  `Write`  | Group can `Read` and `Write` | Public can `Read` and `Write`
- `chmod 766` - Owner can `Read`,  `Write` and `Execute` | Group can `Read` and `Write` | Public can `Read` and `Write`



### Batch permission change



- All the directories and sub-directories. To change all the directories to 755

```
sudo find /var/www/project -type d -exec chmod 755 {} \;
```



- All the files- To change all the files to 644

```
sudo find /var/www/project -type f -exec chmod 644 {} \;
```



### Links

- [Chmod Calculator](https://chmod-calculator.com)

- [Wikipedia]( http://en.wikipedia.org/wiki/Filesystem_permissions)

- [Main page for chmod]( http://linux.die.net/man/1/chmod)
