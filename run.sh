#!/bin/bash

source config.sh

MAX_SLEEP=${MAX_SLEEP:-600}
DATA_FOLDER=${DATA_FOLDER:-/var/www/html/}


while read url; do
   out=$( echo "$url"|md5sum|cut -d " " -f 1 ).json
   echo "Downloading query to $DATA_FOLDER/$out"
   wget -q -O "$DATA_FOLDER/$out" "$url"
   RAND=$(( $RANDOM % $MAX_SLEEP ))
   echo "Sleeping for $RAND seconds between queries"
   sleep $RAND

done<urls.txt
