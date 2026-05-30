#cloud-config
package_upgrade: true

packages:
 - docker.io

runcmd:
 - service docker start
 - docker pull rb1whitney/cloud-boot-app
 - docker run -p ${cba_port_ri}:${cba_port_ri} -e "CBA_ENVIRONMENT=${env_prefix_ri}" -d rb1whitney/cloud-boot-app