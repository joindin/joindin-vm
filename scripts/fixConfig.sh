#!/usr/bin/env bash

VAGRANT_DIR=$PWD;

sed -i 's/https:\/\/m.joind.in/http:\/\/dev.joind.in/' $VAGRANT_DIR/joindin-api/src/config.php
sed -i 's/https:\/\/api.joind.in/http:\/\/api.dev.joind.in/' $VAGRANT_DIR/joindin-web2/config/config.php
