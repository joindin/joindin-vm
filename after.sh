#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

# Create joindin user w/ password
mysql --user="root" --password="secret" -e "CREATE USER 'joindin'@'0.0.0.0' IDENTIFIED BY 'password';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'joindin'@'0.0.0.0' IDENTIFIED BY 'password' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'joindin'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"

# Run migrations
~/joindin-vm/joindin-api/scripts/patchdb.sh -t ~/joindin-vm/joindin-api -d joindin -u homestead -p secret -i

# Import dev DB
php ~/joindin-vm/joindin-api/tools/dbgen/generate.php | mysql -u homestead -psecret joindin

## Install server applications

# Install Wireshark
sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    install tshark -y
