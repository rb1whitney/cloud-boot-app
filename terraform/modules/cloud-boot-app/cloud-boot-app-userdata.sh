#!/bin/bash

echo "Installing Docker and Cloud-Boot-App Image"
sudo yum install -y docker
sudo service docker start
sudo docker pull rb1whitney/cloud-boot-app
echo "Running Cloud-Boot-App Application"
sudo docker run -p 8080:8090 -d rb1whitney/cloud-boot-app