#!/bin/sh

HOSTNAME="$1"
SERVER="$2"

if [ -z "$HOSTNAME" ]; then
    echo "Hostname is missing"
    exit 1
fi

if [ -z "$SERVER" ]; then
    echo "Server is missing"
    exit 1
fi

mkdir -p /coreos/proc
mkdir -p /coreos/dev
mkdir -p /coreos/sys
mkdir -p /coreos/var/run/

sed -i "s/^Hostname\=.*/Hostname\=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Server\=.*/Server\=$SERVER/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive\=.*/ServerActive\=$SERVER/" /etc/zabbix/zabbix_agentd.conf

if [ -f "/etc/zabbix/$HOSTNAME.conf" ]; then
    cat "/etc/zabbix/$HOSTNAME.conf" >> /etc/zabbix/zabbix_agentd.conf
fi

touch /var/spool/cron/crontabs/zabbix
touch /etc/crontab

exec /usr/bin/supervisord
