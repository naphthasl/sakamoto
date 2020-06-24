<br/>
<p align="center">
    <a href="https://github.com/naphthasl/sakamoto" target="_blank">
        <img src="https://raw.githubusercontent.com/naphthasl/sakamoto/master/logo.png" alt="Sakamoto logo">
    </a>
</p>

<br/>
<p align="center">
    <a href="https://github.com/naphthasl/sakamoto/blob/master/LICENSE" target="_blank">
        <img src="https://img.shields.io/github/license/naphthasl/sakamoto?style=plastic" alt="GitHub license">
    </a>
    <a href="https://github.com/naphthasl/sakamoto/issues" target="_blank">
        <img src="https://img.shields.io/github/issues-raw/naphthasl/sakamoto?style=plastic" alt="GitHub open issues">
    </a>
    <a href="https://github.com/naphthasl/sakamoto/issues" target="_blank">
        <img src="https://img.shields.io/github/issues-closed-raw/naphthasl/sakamoto?style=plastic" alt="GitHub closed issues">
    </a>
    <a href="https://github.com/naphthasl/sakamoto/commits/master" target="_blank">
        <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/w/naphthasl/sakamoto?style=plastic">
    </a>
    <a href="https://github.com/naphthasl/sakamoto/graphs/contributors" target="_blank">
        <img src="https://img.shields.io/github/contributors-anon/naphthasl/sakamoto?style=plastic" alt="GitHub contributors">
    </a>
</p>
<br/>


**Sakamoto** is a basic and somewhat adorable **web content management system** written in **Python**. It was designed to be easy to understand, perform as fast as possible and to utilize and intuitive tree-menu system whereby all pages and links on a site are organized into a single tree/index.

<br/>
<p align="center">
    <img width="80%" src="https://raw.githubusercontent.com/naphthasl/sakamoto/master/screenshots/valhalla-01.png" alt="Valhalla Theme Screenshot 01">
</p>
<br/>

This repository contains Sakamoto's **core framework**, default themes and default templates. A theme system is already available, and extensions may be on the way soon.

## 🚀&nbsp; Installation and Configuration

Installing Sakamoto is usually fairly easy, but it depends on whether you intend to use it in a production environment or if you intend to contribute to the code.

Instructions for popular distributions have been provided here. You can adapt them for your own pretty easily.

### Fedora Server 28+ OR Fedora Workstation 28+

Installation:
```bash
# Install dependencies
sudo dnf install python3 python3-pip python3-devel python3-setuptools python3-virtualenv libev-devel git

# Clone from GitHub
git clone https://github.com/naphthasl/sakamoto sakamoto

# Create virtual environment
mkdir sakamoto/environment
virtualenv sakamoto/environment
cd sakamoto

# Activate virtual environment
source environment/bin/activate

# Install more dependencies within virtual environment
pip3 install -r requirements.txt

# Perform first-time launch, which will create the primary config file
python3 sakamoto.py

# Edit the config file (set default admin details, configure database access)
nano config.toml

# Deactivate virtual environment
deactivate
```

Running:
```bash
source environment/bin/activate
python3 sakamoto.py
deactivate
```

### Debian-based

Same instructions as Fedora, except replace the "Install Dependencies" stage with the following:
```bash
# Install dependencies
sudo apt update
sudo apt install software-properties-common git
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev libev-dev
sudo apt install python3.8-distutils python3.8-dev
sudo python3.8 -m pip install --upgrade pip setuptools wheel
python3.8 -m pip install --user virtualenv
```