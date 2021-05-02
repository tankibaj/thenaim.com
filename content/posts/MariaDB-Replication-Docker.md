+++
title = 'MariaDB replication in Docker'
image = '/images/post/mariadb.png'
author = 'Naim'
date = 2021-02-12
description = 'Setting up mariaDB replication on Docker'
categories = ["mariadb","replication","docker"]
type = 'post'
+++

MariaDB is a free, open-source and one of the most popular open-source relational database management system. It is a drop-in replacement for MySQL intended to remain free under the GNU GPL. You will need to increase your MariaDB server's instances and replicate the data on multiple servers when your traffic grows. The Master-Slave replication provides load balancing for the databases. It doesn't use for any failover solution. Master-Slave replication data changes happen on the master server, while the slave server automatically replicates the changes from the master server. This mode will be best suited for data backups.

## Goal

- Create two docker containers with MariaDB server, one will be Master server and another will be Slave server.
- A simple PHP script to test replication.
- Every minute scheduled Cron job to check replication health and write health status log and docker exit code into Syslog.
- If replication fails or stops get a notification via email.



## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Manage Docker as a non-root user for Linux](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)


## Clone github repository

```bash
git clone https://github.com/tankibaj/Mariadb-Replication-Docker.git Mariadb-Replication && cd Mariadb-Replication
```

## Command and usage

- `bash kickoff.sh`  - [Building Image and Run](https://i.imgur.com/AwIejDo.png) Master, Slave and PHP nodes. 
- `bash status.sh` - Checkout replication [Status](https://imgur.com/cxnUEYH) on terminal.
- `sudo bash setupCronJob.sh` - Setup cron job for every minute.
- `tail -f /var/log/syslog | grep REPLICATION` - Checkout replication status from [SysLog](https://imgur.com/59f58ho). Make sure you have already configured  `bash setupCronJob.sh`.
- `bash stopSlave.sh` - Stop Slave node.
- `bash startSlave.sh` - Start Slave node.
- `bash stopPHP.sh` - Stop PHP node. By default, the PHP node will keep hitting the Master node by inserting and updating data. If you want, you can modify php script `php-image/app/hammer.php` and re-build image.
- `bash startPHP.sh` - Start PHP node.
- `bash destroy.sh` - Destroy all nodes.
- `.env` |`.docker.env` - Declare default environment variables.
- Email notification - If you would like to get an email notification on replication failure, then you have to add a Sendgrid API key to the `.env` file and enable the function called `sendEmail()` from `daemon.sh`.
