#!/bin/bash

export PATH="/usr/local/bin:$PATH"

cd $1
exec $2
