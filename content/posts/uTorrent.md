+++
title = 'uTorrent WebUI on Ubuntu Server'
image = '/images/post/utorrent.png'
author = 'Naim'
date = 2019-01-20
description = 'Setting up uTorrent WebUI on Ubuntu Server'
categories = ["utorrent","ubuntu"]
type = 'post'
+++

uTorrent is the world most popular BitTorrent client. It’s available to the Ubuntu server with webUI.


Table of Contents
=================

* [Download uTorrent](#download-utorrent)
* [Install dependencies](#install-dependencies)
* [Install uTorrent](#install-utorrent)
* [Auto Start uTorrent Server on Ubuntu](#auto-start-utorrent-server-on-ubuntu)
* [Setting up Nginx Reverse Proxy](#setting-up-nginx-reverse-proxy)
    * [Sub\-domain Configuration](#sub-domain-configuration)
* [Setting up Apache Reverse Proxy](#setting-up-apache-reverse-proxy)
* [Uninstall uTorrent](#uninstall-utorrent)
* [Folders and Permissions](#folders-and-permissions)


## Download uTorrent

```bash
sudo wget http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0/utserver.tar.gz
```



## Install dependencies

```bash
apt install libssl1.0.0 libssl-dev
```



**[Optional] Download dependencies and install pkg: [docs](https://packages.debian.org/jessie/libssl1.0.0)**

```bash
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.5_amd64.deb
sudo apt install ./libssl1.0.0_1.0.2n-1ubuntu5.5_amd64.deb
```



## Install uTorrent

Use the following commands to extract the `tar.gz` file to `/opt/` directory,  create a symbolic link and start uTorrent server. By default, uTorrent server listens on `0.0.0.0:8080`. If there’s another service also listens on port 8080, you should temporarily stop that service. uTorrent will also use port 10000 and 6881.

```shell
sudo tar -zxvf utserver.tar.gz -C /opt/ && \
sudo chmod 777 /opt/utorrent-server-alpha-v3_3/ && \
sudo ln -s /opt/utorrent-server-alpha-v3_3/utserver /usr/bin/utserver && \
sudo utserver -settingspath /opt/utorrent-server-alpha-v3_3/ &
```



You can now visit the uTorrent web UI in your browser by entering

```url
http://your-server-ip:8080/gui
# User: admin
# Password: leave blank
```



## Auto Start uTorrent Server on Ubuntu

To enable auto start, we can create a systemd service.

```bash
sudo nano /etc/systemd/system/utserver.service
```



Put the following text into the file.

```
[Unit]
Description=uTorrent Server
After=network.target

[Service]
Type=simple
User=utorrent
Group=utorrent
ExecStart=/usr/bin/utserver -settingspath /opt/utorrent-server-alpha-v3_3/ &
ExecStop=/usr/bin/pkill utserver
Restart=always
SyslogIdentifier=uTorrent Server

[Install]
WantedBy=multi-user.target
```



Save and close the file. Then reload systemd.

```bash
sudo systemctl daemon-reload
```



Note that it’s recommended not to run uTorrent server as root, so we’ve specified in the service file that uTorrent server should run as the `utorrent` user and group, which have no root privileges. Create the `utorrent` system user and group with the following command.

```bash
sudo adduser --system utorrent && \
sudo addgroup --system utorrent
```



Add the `utorrent` user to the `utorrent` group.

```bash
sudo adduser utorrent utorrent
```



Next, Stop the current uTorrent server.

```bash
sudo pkill utserver
```



Use the systemd service to start uTorrent server.

```bash
sudo systemctl start utserver
```



Enable auto start at boot time.

```bash
sudo systemctl enable utserver
```



Now check utserver satus.

```bash
systemctl status utserver
```



We can see that auto start is enabled and uTorrent server is running. When creating the `utorrent` user, a home directory was also created at `/home/utorrent/`. It’s recommended that you set this home directory as your torrent download directory because the utorrent user has write permission. We also need to make utorrent as the owner of the `/opt/utorrent-server-alpha-v3_3/` directory by executing the following command.

```bash
sudo chown -R utorrent:utorrent /opt/utorrent-server-alpha-v3_3/
```



## Setting up Nginx Reverse Proxy

To access your uTorrent server from a remote connection using a domain name, you can set up Nginx reverse proxy.



#### Sub-domain Configuration



Create a new server block

```bash
sudo nano /etc/nginx/sites-available/utorrent
```



**HTTPS**: Paste the following text into the file.  Replace `utorrent.example.com` with your preferred sub-domain and don’t forget to create A record for it.

```nginx
server {
  listen 80;
  listen [::]:80;
  server_name utorrent.example.com;
  return 302 https://$server_name$request_uri;
}

server {

  # SSL configuration

  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  ssl_certificate         /etc/nginx/ssl/example/cert.crt;
  ssl_certificate_key     /etc/nginx/ssl/example/key.pem;
  ssl_client_certificate  /etc/nginx/ssl/example/cloudflare.crt;
  ssl_verify_client on;
  
  server_name utorrent.example.com;

  location /gui {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }


}
```



**HTTP**: Paste the following text into the file.  Replace `utorrent.example.com` with your preferred sub-domain and don’t forget to create A record for it.

```nginx
server {
	listen 80;
	server_name utorrent.example.com;

	location /gui {
		proxy_pass http://localhost:8080;
		proxy_set_header Host $http_host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```



After adding this content, save and close the file. Enable your new server block by creating a symbolic link from your new server block configuration file (in the `/etc/nginx/sites-available/` directory) to the `/etc/nginx/sites-enabled/` directory:

```bash
sudo ln -s /etc/nginx/sites-available/utorrent /etc/nginx/sites-enabled/
```



Test your new configuration file for syntax errors by typing:

```bash
sudo nginx -t
```



If any errors are reported, go back and recheck your file before continuing. When you are ready, reload Nginx to make the necessary changes:

```bash
sudo systemctl reload nginx
```



Now you can access uTorrent Web UI via

```
utorrent.example.com
```



## Setting up Apache Reverse Proxy

If you use Apache web server rather than Nginx, then follow the instructions below to set up reverse proxy.



To use Apache as a reverse proxy, we need to enable the `proxy` modules and we will also enable the `rewrite` module.

```bash
sudo a2enmod proxy proxy_http rewrite
```



Then create a virtual host file for uTorrent.

```bash
sudo nano /etc/apache2/sites-available/utorrent.conf
```



Put the following configurations into the file. Replace `utorrent.example.com` with your actual domain name and don’t forget to set an A record for it.

```apache
<VirtualHost *:80>
    ServerName utorrent.example.com

    RewriteEngine on
    RewriteRule ^/gui(/?)(.*)$ /$2 [PT]

    ProxyPreserveHost on
    ProxyPass / http://127.0.0.1:8080/gui/
    ProxyPassReverse / http://127.0.0.1:8080/gui/
</VirtualHost>
```



Save and close the file. Then enable this virtual host.

```bash
sudo a2ensite utorrent.conf
```



Restart Apache for the changes to take effect.

```bash
sudo systemctl restart apache2
```



Now you can remotely access uTorrent server by entering the subdomain ( utorrent.example.com ) in browser address bar. If uTorrent Web UI doesn’t load, then you may need to delete the default virtual host file and restart Apache web server.





## Uninstall uTorrent

Run the following commands to uninstall:

```bash
sudo pkill utserver && \
sudo rm -rf /opt/utorrent-server-alpha-v3_3 && \
sudo rm -rf /usr/bin/utserver
```



## Folders and Permissions

Create two folders, one for store download files other store torrent files.

```bash
sudo mkdir dl
sudo mkdir torrentfiles
```

Create a new user gorup, this gorup members will have full access of `torrentfiles` folder.

```bash
sudo groupadd torrent-files
sudo usermod -a -G torrent-files ubuntu
```

Change `torrentfiles` folder permission

```bash
sudo chown -R utorrent /home/utorrent/torrentfiles/
sudo chgrp -R torrent-files /home/utorrent/torrentfiles/
sudo chmod -R 770 /home/utorrent/torrentfiles/
sudo chmod g+s /home/utorrent/torrentfiles/
```

Create a new user gorup, this gorup members will have full access of `dl` folder.

```bash
sudo groupadd torrent-dl
sudo usermod -a -G torrent-dl ubuntu
sudo usermod -a -G torrent-dl www-data
```

Change `dl` folder permission

```bash
sudo chown -R utorrent /home/utorrent/dl/
sudo chgrp -R torrent-dl /home/utorrent/dl/
sudo chmod -R 770 /home/utorrent/dl/
sudo chmod g+s /home/utorrent/dl/
```

