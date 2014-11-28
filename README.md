docker-monetdb 
==============

Dockerized MonetDB distribution's image based on phusion/baseimage:0.9.15.

To properly run the container type the following command

docker run -d -P --name monetdb sramazzina/docker-monetdb 

Monetdb starts with a database called dm1 already created; once started you 
can access it through port 50000. By using the default user monetdb with 
password monetdb.

To connect to the internal dm1 database type the following command

docker run --rm -it test-monetdb /bin/bash -c 'mclient -h <your_docker_container_ip> -p 50000 -d dm1'

where <your_docker_container_ip> is the ip address assigned to your docker container. 
