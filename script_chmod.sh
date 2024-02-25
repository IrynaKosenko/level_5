#!/bin/bash

dir="test"

if [ ! -d "$dir" ]; then
    echo "Directory $dir doesnt exist"
fi

find $dir -type d -name "*" -exec chmod 770 {} \;  # this also changes permission for root folder


find $dir -type f -name "*" -exec chmod 660 {} \;