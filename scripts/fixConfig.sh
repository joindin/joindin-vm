#!/usr/bin/env bash

VAGRANT_DIR=$PWD;

if [[ ! -e $VAGRANT_DIR/joindin-api/src/config.php ]]; then
    echo "api config missing... fixing";
    cp $VAGRANT_DIR/joindin-api/src/config.php.dist $VAGRANT_DIR/joindin-api/src/config.php;
fi

if [[ ! -f $VAGRANT_DIR/joindin-api/src/database.php ]]; then
    echo "api database-config missing... fixing";
    cp $VAGRANT_DIR/joindin-api/src/database.php.dist $VAGRANT_DIR/joindin-api/src/database.php;
fi

if [[ ! -f $VAGRANT_DIR/joindin-web2/config/config.php ]]; then
    echo "Web config missing... fixing";
    cp $VAGRANT_DIR/joindin-web2/config/config.php.dist $VAGRANT_DIR/joindin-web2/config/config.php;
fi

sed -i 's/https:\/\/m.joind.in/http:\/\/dev.joind.in/' $VAGRANT_DIR/joindin-api/src/config.php
sed -i 's/https:\/\/api.joind.in/http:\/\/api.dev.joind.in/' $VAGRANT_DIR/joindin-web2/config/config.php
