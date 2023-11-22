#!/bin/bash

apt-get update
apt install -y openssh-server
apt install -y cron
apt install -y default-jdk
apt install -y vim
apt install -y zip
apt install -y sqlite3



# ssh serve
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# ssh connection immediately disconnects after session start with exit code 254:
# https://unix.stackexchange.com/questions/148714/cant-ssh-connection-terminates-immediately-with-exit-status-254
sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config