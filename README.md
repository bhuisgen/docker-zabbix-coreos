# Docker Zabbix for CoreOS server

This Docker container provides a patched Zabbix agent to monitor a real CoreOS server and all his containers.

The Zabbix agent has been patched to read system informations from these directories:

* */coreos/proc* which is a mapping of */proc* from the real host 
* */coreos/dev* which is a mapping of */dev* from the real host 
* */coreos/sys* which is a mapping of */sys* from the real host 

You can access the Docker REST API through the socket file */coreos/var/run/docker.sock*

## Usage

### Build the image

    # docker build -t bhuisgen/zabbix-agent .

### Run the container

    # docker run -d -p 10050:10050 \
        -v /proc:/coreos/proc -v /sys:/coreos/sys -v /dev:/coreos/dev
        -v /var/run/docker.sock:/coreos/var/run/docker.sock
        --name zabbix-agent bhuisgen/zabbix-agent
