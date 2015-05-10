FROM debian:sid
MAINTAINER Boris HUISGEN <bhuisgen@hbis.fr>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install locales
RUN dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get -y install ucf procps iproute

RUN apt-get update && apt-get -y install supervisor
COPY etc/supervisor/ /etc/supervisor/

RUN apt-get update && apt-get -y install --no-install-recommends \
    cron \
    curl \
    jq \
    libcurl3-gnutls \
    libldap-2.4-2 \
    netcat-openbsd \
    pciutils \
    sudo \
    vim

COPY files/zabbix-agent_2.2.7+dfsg-1.1_amd64.deb /root/
RUN dpkg -i /root/zabbix-agent_2.2.7+dfsg-1.1_amd64.deb
COPY etc/zabbix/ /etc/zabbix/
RUN mkdir -p /var/lib/zabbix && chmod 700 /var/lib/zabbix && chown zabbix:zabbix /var/lib/zabbix && usermod -d /var/lib/zabbix zabbix && usermod -a -G adm zabbix
COPY etc/sudoers.d/zabbix etc/sudoers.d/zabbix
RUN chmod 400 /etc/sudoers.d/zabbix
COPY etc/zabbix/crontab /var/spool/cron/crontabs/zabbix
RUN chmod 600 /var/spool/cron/crontabs/zabbix && chown zabbix:crontab /var/spool/cron/crontabs/zabbix

COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 10050
ENTRYPOINT ["/run.sh"]
CMD [""]
