#!/bin/bash
dwctl volume create wp-vol -v vol1,1G,ext4
dwctl pod create mysql -i docker.io/mysql:5.5 -v wp-vol/vol1:/var/lib/mysql,rw -n blue -c 1250 -m 750M -l mysql -e MYSQL_ROOT_PASSWORD=root,MYSQL_DATABASE=blog,MYSQL_USER=mysql,MYSQL_PASSWORD=mysql
dwctl pod create wordpress -i docker.io/wordpress:4.3.1 -v /var/www/html,rw,100M,ext4 -n blue -c 1250 -m 100M -l wordpress -e WORDPRESS_DB_HOST=mysql.mycluster.datawise.io,WORDPRESS_DB_USER=mysql,WORDPRESS_DB_PASSWORD=mysql,WORDPRESS_DB_NAME=blog

