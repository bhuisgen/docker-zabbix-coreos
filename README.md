# Docker Zabbix for CoreOS server

This Docker container provides a patched Zabbix agent to monitor a real CoreOS server and all his containers.

The Zabbix agent has been patched to read system informations from these directories:

* */coreos/proc* mapped from */proc* on the real host
* */coreos/dev* mapped from */dev* on the real host
* */coreos/sys* mapped from */sys* on the real host

You can access the Docker REST API through the socket file */coreos/var/run/docker.sock*

## Usage

### Build the image

    # docker build -t bhuisgen/docker-zabbix-coreos .

### Run the container

    # docker run -d -p 10050:10050 \
        -v /proc:/coreos/proc -v /sys:/coreos/sys -v /dev:/coreos/dev \
        -v /var/run/docker.sock:/coreos/var/run/docker.sock
        --name zabbix-coreos bhuisgen/docker-zabbix-coreos <HOSTNAME> <SERVER_IP>

The needed arguments are:

* *HOSTNAME*: name of the host declared in the Zabbix frontend
* *SERVER*: IP address of the Zabbix server

### Modify the agent configuration files

    # docker exec -ti zabbix-coreos /bin/bash

### Restarting the agent

    # supervisorctl restart zabbix
