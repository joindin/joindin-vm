#!/bin/sh

sed -i 's/https:\/\/m.joind.in/http:\/\/dev.joind.in/' /vagrant/joindin-api/src/config.php
sed -i 's/https:\/\/api.joind.in/http:\/\/api.dev.joind.in/' /vagrant/joindin-web2/config/config.php

