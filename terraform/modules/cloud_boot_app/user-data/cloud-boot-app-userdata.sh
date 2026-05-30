#!/bin/bash

port=${cba_port_ri}
environment_prefix=${env_prefix_ri}

echo "Installing Docker"
sudo apt-get install -y docker.io
sudo service docker start

echo "Running Cloud-Boot-App Application on $port"
sudo docker pull rb1whitney/cloud-boot-app
sudo docker run -p $port:$port -e "CBA_ENVIRONMENT=$environment_prefix" -d rb1whitney/cloud-boot-app