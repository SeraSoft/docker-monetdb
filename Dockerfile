# VERSION	1.0

FROM phusion/baseimage:0.9.19
MAINTAINER Sergio Ramazzina, sergio.ramazzina@serasoft.it

ENV DWH_NAME dm1
ENV DBFARM_ROOT /opt
ENV DBFARM_DIR monet-dbfarm

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Create monetdb user
RUN groupadd -r serasoft && \
    useradd -r -g serasoft monetdb

#Make sure package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    echo "deb http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    echo "deb-src http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    apt-get install wget -y && \
    wget --output-document=- http://dev.monetdb.org/downloads/MonetDB-GPG-KEY | apt-key add - && \
    apt-get update -y && \
    apt-get install -y monetdb5-sql monetdb-client

# Call init_db.sh script to initialize MonetDB database
ADD init_db.sh /opt
RUN chmod +x /opt/init_db.sh && \
	/opt/init_db.sh

# Add monetdb startup script
RUN mkdir /etc/service/monetdb
ADD start_monetdb.sh /etc/service/monetdb/run
RUN chown -R monetdb:serasoft /etc/service/monetdb

RUN rm -f /etc/service/sshd/down && \
    echo "/usr/sbin/sshd > log &" >> /etc/my_init.d/00_regen_ssh_host_keys.sh

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Expose ports.
EXPOSE 50000
# Add VOLUME for monetdb dbfarm data backup
VOLUME /opt/monet-dbfarm

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
