#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

# Run migrations
~/code/joindin-api/scripts/patchdb.sh -t ~/code/joindin-api -d joindin -u homestead -p secret -i

# Import dev DB
php ~/code/joindin-api/tools/dbgen/generate.php | mysql -u homestead -psecret joindin

## Install server applications

# Install Wireshark
sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    install tshark -y
