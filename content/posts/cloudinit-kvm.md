+++
title = 'Cloudinit - Spin up a kvm vm instantly without os installation'
image = '/images/post/kvm.png'
author = 'Naim'
date = 2021-02-15
description = 'Setting up cloudinit in KVM'
categories = ["cloudinit","kvm","ubuntu"]
type = 'post'
+++



Spin up a virtual machine instance in a few seconds with [cloud image](https://cloud-images.ubuntu.com/) and [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) is a familiar practice on cloud platforms like AWS, GCP, and Azure. [Cloud image](https://cloud-images.ubuntu.com/) and [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) are not just for cloud providers, it can be deployed in KVM to spin up a virtual machine instantly without guest os installation.

The goal is to create a VM instance in KVM with [cloud image](https://cloud-images.ubuntu.com/) and [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html).



### Prerequisites

[Installed KVM and libvirt](/posts/kvm-ubuntu/)

### Clone github repository

```bash
git clone https://github.com/tankibaj/Cloudinit-KVM.git Cloudinit-KVM && cd Cloudinit-KVM
```


### Getting started

- ###### Update and install cloud image utils

  ```bash
  sudo apt update && sudo apt install -y cloud-image-utils
  ```

- ###### Cloud-Init configuration

  ```bash
  nano user-data.yml
  ```

- ###### Network configuration

  ```bash
  nano network-config.yml
  ```

- ###### Spin up Ubuntu 20.04 VM

  ```bash
  bash CreateInstance.sh ubuntu-instance ubuntu 20 5902
  ```
  
  - ###### Spin up Debian 10 VM

  ```bash
  bash CreateInstance.sh debian-instance debian 20 5903
  ```

 

### Resource

- [An Introduction to Cloud-Config Scripting](https://www.digitalocean.com/community/tutorials/an-introduction-to-cloud-config-scripting)
- [Cloud-init Documentation](https://cloudinit.readthedocs.io/en/latest/)
- [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)