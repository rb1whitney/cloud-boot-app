VAGRANTFILE_API_VERSION = '2'

# Test Script to duplicate AWS Machine
$cba_cloud_init = <<SCRIPT
port=8090
environment_prefix=dev

sudo apt-get install -y docker.io
sudo service docker start
sudo docker pull rb1whitney/cloud-boot-app
sudo docker run -p $port:$port -e "CBA_ENVIRONMENT=$environment_prefix" -d rb1whitney/cloud-boot-app
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = true
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true
  config.vm.hostname = "docker-cloud-boot-app"
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.provision "shell", inline: $cba_cloud_init
end