#!/bin/bash

#echo "Installing Docker"
sudo apt-get install -y docker.io
sudo service docker start

# If installing on RHEL or Centos
#sudo yum install -y docker
#systemctl start docker
#systemctl enable docker

echo "Running Cloud-Boot-App Application"
sudo docker pull rb1whitney/cloud-boot-app
sudo docker run -p 8090:8090 -d rb1whitney/cloud-boot-app