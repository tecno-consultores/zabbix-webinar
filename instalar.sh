#!/usr/bin/env bash
# Made by Sinfallas <sinfallas@yahoo.com>
# Licence: GPL-2
LC_ALL=C

# Check if the script is run as root
if [[ "$EUID" != "0" ]]; then
	echo -e "\e[00;31mERROR: Debes ser root.\e[00m"
	exit 1
fi

# Install Docker on Ubuntu
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8
apt update
apt -y install docker-ce-rootless-extras docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin uidmap

# add current user to the docker group
quienh=$(ls -l /home | awk '{print $9}' | grep -v "lost+found" | tail -n +2)
for j in ${quienh[@]}; do
	usermod -aG docker $j
done

# install zabbix
docker compose -f docker-compose.yaml up -d

echo "Zabbix instalado correctamente."