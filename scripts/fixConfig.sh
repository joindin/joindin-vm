#!/bin/sh

sed -i 's/https:\/\/api.joind.in/http:\/\/api.dev.joind.in/' /vagrant/joindin-web2/config/config.php
sed -i 's/https:\/\/joind.in\//http:\/\/dev.joind.in:8080\//' /vagrant/joind.in/src/system/application/config/config.php
sed -i 's/https:\/\/api.joind.in\//http:\/\/api.dev.joind.in:8080\//' /vagrant/joind.in/src/system/application/config/config.php
sed -i "s/^\$config\['token_dir'].*/\$config\['token_dir'\] = '\/tmp\/ctokens';/" /vagrant/joind.in/src/system/application/config/config.php

