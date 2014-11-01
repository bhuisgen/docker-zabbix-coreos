FROM debian:sid
MAINTAINER Boris HUISGEN <bhuisgen@hbis.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install locales
RUN dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -y install ucf procps iproute

RUN apt-get -y install supervisor
COPY etc/supervisor/ /etc/supervisor/

COPY files/zabbix-agent_2.2.6+dfsg-2_amd64.deb /root/
RUN apt-get -y install pciutils libcurl3-gnutls libldap-2.4-2 curl netcat-openbsd
RUN dpkg -i /root/zabbix-agent_2.2.6+dfsg-2_amd64.deb
COPY etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

COPY run.sh /
RUN chmod +x /run.sh

VOLUME  ["/etc/zabbix"]
EXPOSE 10050
ENTRYPOINT ["/run.sh"]
CMD [""]
