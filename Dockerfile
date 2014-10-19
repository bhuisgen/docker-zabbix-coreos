FROM debian:sid
MAINTAINER Boris HUISGEN <bhuisgen@hbis.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install supervisor ucf 
COPY etc/supervisor/conf.d/supervisor.conf /etc/supervisor/conf.d/

COPY files/zabbix-agent_2.2.6+dfsg-2_amd64.deb /root/
RUN apt-get -y install pciutils libcurl3-gnutls libldap-2.4-2 netcat-openbsd  
RUN dpkg -i /root/zabbix-agent_2.2.6+dfsg-2_amd64.deb
COPY etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

COPY run.sh /
RUN chmod +x /run.sh

VOLUME  ["/etc/zabbix"]
EXPOSE 10050
ENTRYPOINT ["/run.sh"]
CMD [""]
