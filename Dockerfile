FROM debian:sid
MAINTAINER Boris HUISGEN "bhuisgen@hbis.fr"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoclean && apt-get -y autoremove
RUN apt-get -y install supervisor ucf 

COPY zabbix-agent_2.2.6+dfsg-2_amd64.deb /root/zabbix-agent_2.2.6+dfsg-2_amd64.deb
 
RUN apt-get -y install pciutils libcurl3-gnutls libldap-2.4-2 netcat-openbsd  
RUN dpkg -i /root/zabbix-agent_2.2.6+dfsg-2_amd64.deb

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

RUN mkdir /coreos

EXPOSE 10050
CMD ["/usr/bin/supervisord"]
