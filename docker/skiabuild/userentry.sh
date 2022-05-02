#!/bin/bash

export PATH="/usr/local/bin:$PATH"

export HOME=/home/${CURRENT_USER}

cd $1
exec $2
