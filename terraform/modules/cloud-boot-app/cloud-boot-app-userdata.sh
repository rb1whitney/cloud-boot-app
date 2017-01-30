#!/bin/bash

port=${cloud_boot_server_port}

#echo "Installing Docker"
sudo apt-get install -y docker.io
sudo service docker start

# If installing on RHEL or Centos
#sudo yum install -y docker
#systemctl start docker
#systemctl enable docker

echo "Running Cloud-Boot-App Application on $port"
sudo docker pull rb1whitney/cloud-boot-app
sudo docker run -p $port:$port -d rb1whitney/cloud-boot-app