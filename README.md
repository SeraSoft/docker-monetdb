docker-monetdb 
==============

Dockerized MonetDB distribution's image based on phusion/baseimage:0.9.15.

To properly run the container type the following command

docker run -d sramazzina/docker-monetdb 

Monetdb starts with a database called dm1 already created; once started you 
can access it through port 50000. By using the default user monetdb with 
password monetdb.
