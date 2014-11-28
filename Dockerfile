# VERSION	1.0

FROM phusion/baseimage:0.9.15
MAINTAINER Sergio Ramazzina, sergio.ramazzina@serasoft.it

# Set correct environment variables.
ENV HOME /root
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Make sure package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    echo "deb http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    echo "deb-src http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    apt-get install wget -y && \
    wget --output-document=- http://dev.monetdb.org/downloads/MonetDB-GPG-KEY | apt-key add - && \
    apt-get update -y && \
    apt-get install -y monetdb5-sql monetdb-client

# Create dbfarm and a first database	
RUN monetdbd create /opt/monet-dbfarm && \
	monetdbd start /opt/monet-dbfarm && \
	monetdb create dm1 && \
	monetdb start dm1 && \
	monetdb release dm1 && \
	monetdbd stop /opt/monet-dbfarm	
# Expose ports.
EXPOSE 50000

# Add monetdb startup script
RUN mkdir /etc/service/monetdb
ADD start_monetdb.sh /etc/service/monetdb/run


