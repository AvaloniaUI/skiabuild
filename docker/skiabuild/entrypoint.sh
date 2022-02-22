#!/bin/bash

groupadd -g ${CURRENT_GID} usergroup
useradd -M -u ${CURRENT_UID} -g ${CURRENT_GID} ${CURRENT_USER}

usermod -a -G wheel ${CURRENT_USER}

echo "root   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "${CURRENT_USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

exec sudo -i -u ${CURRENT_USER} /userentry.sh ${CURRENT_DIR} $@

