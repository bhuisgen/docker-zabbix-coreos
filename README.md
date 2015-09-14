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

### Configure your Zabbix server

#### Import templates

Import the needed templates in *etc/zabbix/templates*

#### Create auto-registration action (optional)

To automatically create new host on the zabbix server, create a auto-registration action (Configuration/Actions/Auto-registration):

* conditions: Host metadata like 'coreos'
* actions: Add Host, Add host to groups, Link to templates (Custom Template CoreOS, Custom Template Docker, Template App SSH Service, Template ICMP Ping, Template OS Linux)

The host metadata value is the value shared by all your cluster nodes. Each node must shared the same value.

If you don't want to use the auto-registration, you must add each node in the frontend.

### Run the container

#### Docker

To create the container:

    # docker run -d -p 10050:10050 \
        -v /proc:/coreos/proc:ro -v /sys:/coreos/sys:ro -v /dev:/coreos/dev:ro \
        -v /var/run/docker.sock:/coreos/var/run/docker.sock \
        --name zabbix-coreos bhuisgen/docker-zabbix-coreos <SERVER> <HOSTMETADATA> [<HOSTNAME>]

If you want to access directly to the network stack of the node, you can use the *host* network mode but it is less secure:

    # docker run -d -p 10050:10050 --net="host" \
        -v /proc:/coreos/proc:ro -v /sys:/coreos/sys:ro -v /dev:/coreos/dev:ro \
        -v /var/run/docker.sock:/coreos/var/run/docker.sock \
        --name zabbix-coreos bhuisgen/docker-zabbix-coreos <SERVER> <HOSTMETADATA> [<HOSTNAME>]

The needed options are:

* *SERVER* (required): the IP address of the Zabbix server
* *HOSTMETADATA* (required): the metadata value shared by all servers on the same cluster. This value will match the autoregistration action
* *HOSTNAME* (optional): the hostname used by this agent in the zabbix frontend. If no value is given, the machine id of the host will be used

The agent will start and the auto-registration will add your agent if a auto-registration action is matched for your host metadata. If you don't want to auto-register your nodes, you need to specify the hostname value to use.

#### Fleet

Copy this file:

    # cp files/fleet/zabbix-agent /etc/default/zabbix-agent

Each node will be created with the machine id into the Zabbix frontend.

Edit the environment file to set the configuration settings:

    # vim /etc/default/zabbix-agent

The configuration settings are:

* *SERVER*: the IP address of the Zabbix server
* *HOSTMETADATA* (required): the metadata value shared by all servers on the same cluster. This value will match the autoregistration action

You can start the agent on all your cluster nodes with fleet:

    # fleetctl submit zabbix-agent
    # fleetctl start zabbix-agent

If you don't want to use auto-registration, create your service unit file. You can use the template in *files/systemd*.

### FAQ

#### What is the machine id of my host ?

    # cat /etc/machine-id

#### How to modify the agent configuration files ?

    # docker exec -ti zabbix-coreos /bin/bash

Inside the container:

    # cd /etc/zabbix/

#### How to restart the agent ?

    # docker exec -ti zabbix-coreos /bin/bash

Inside the container:

    # supervisorctl restart zabbix-agent

#### How to add custom user parameters for a host ?

Create a custom configuration file *HOSTNAME.conf* in *etc/zabbix/* where HOSTNAME matches the value used for your host agent. Docker will concatenate this file into the main configuration file before running the container.

Exemple 1: with manual registration, if your zabbix host is *myhost*:

    # vim etc/zabbix/5bcc6a59c4234d1eac3d6c57e3e58eff.conf

Exemple 2: with auto-registration, if you use *cluster* as host metadata and *5bcc6a59c4234d1eac3d6c57e3e58eff* is the machine id of your real host:

    # vim etc/zabbix/cluster-5bcc6a59c4234d1eac3d6c57e3e58eff.conf
