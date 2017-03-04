#!/bin/sh

# update the system
yum -y update
yum -y upgrade

################################################################################
# This is a port of the JHipster Dockerfile,
# see https://github.com/jhipster/jhipster-docker/
################################################################################

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# install utilities
yum -y install vim git zip bzip2 fontconfig curl language-pack-en

# install Java 8
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"
tar xzf jdk-8u121-linux-x64.tar.gz
rm -f jdk-8u121-linux-x64.tar.gz
export JAVA_HOME=/opt/jdk1.8.0_121
export JRE_HOME=/opt/jdk1.8.0_121/jre
export PATH=$PATH:/opt/jdk1.8.0_121/bin:/opt/jdk1.8.0_121/jre/bin

# install development tools
yum install -y unzip python gcc gcc-c++ make openssl-devel kernel-devel

# install nodejs
curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum install -y nodejs

# install npm
npm install -g npm

# install yeoman bower gulp
npm install -g yo grunt-cli bower gulp

# install JHipster
npm install -g generator-jhipster

# install JHipster UML
npm install -g jhipster-uml

################################################################################
# Install the graphical environment
################################################################################

# force encoding
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# install a graphical desktop, make it the default
yum groupinstall -y "GNOME Desktop" "Graphical Administration Tools"
systemctl set-default graphical.target

# for installing Virtual Box Additions
# do this second so Xwindows is there before the additions run
mount /dev/sr0 /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /dev/sr0 /mnt

# remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
yum remove -y light-locker

################################################################################
# Install the development tools
################################################################################

# install Chromium Browser
yum install -y google-chrome-stable.`uname -m`

# install Cloud Foundry client
cd /opt && curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
ln -s /opt/cf /usr/bin/cf

# install zsh
yum install -y zsh

# install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
echo 'SHELL=/bin/zsh' >> /etc/environment

# install jhipster-oh-my-zsh-plugin
git clone https://github.com/jhipster/jhipster-oh-my-zsh-plugin.git /home/vagrant/.oh-my-zsh/custom/plugins/jhipster
sed -i -e "s/plugins=(git)/plugins=(git docker docker-compose jhipster)/g" /home/vagrant/.zshrc

# change user to vagrant
chown -R vagrant:vagrant /home/vagrant/.zshrc /home/vagrant/.oh-my-zsh

# install Docker
curl -sL https://get.docker.io/ | sh
service docker start

# install docker compose
curl -k -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# configure vboxsf group (ensure vagrant can access the shared folder mapped by Host at /media/sf_xxx)
usermod -aG vboxsf vagrant

# clean the box
yum -y clean all
yum -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
