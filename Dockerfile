# Docker image for Serasoft's Pentaho Business Analytics training courses
#
# VERSION	1.0

FROM phusion/baseimage:0.9.15
MAINTAINER Sergio Ramazzina, sergio.ramazzina@serasoft.it

# Make sure package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    echo "deb http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    echo "deb-src http://dev.monetdb.org/downloads/deb/ trusty monetdb" >> /etc/apt/sources.list.d/monetdb.list && \
    apt-get install wget -y && \
    wget --output-document=- http://dev.monetdb.org/downloads/MonetDB-GPG-KEY | apt-key add - && \
    apt-get update -y && \
    apt-get install -y monetdb5-sql monetdb-client && \
# Create dbfarm and a first database	
RUN monetdbd create /opt/monet-dbfarm && \
	monetdb create dm1 && \
	monetdb start dm1 && \
	monetdb release dm1
	

# Expose ports.
EXPOSE 54321
	
CMD ["monetdbd", "/opt/monet-dbfarm", "start"]


