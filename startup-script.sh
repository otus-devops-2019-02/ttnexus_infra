#!/bin/bash

#Installing Ruby and Bundler
apt update
apt install -y ruby-full ruby-bundler build-essential


#Install Mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential
systemctl start mongod
systemctl enable mongod

#Get app and start app
sudo -s appuser
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d


