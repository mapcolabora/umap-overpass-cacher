#!/bin/bash

source config.sh

MAX_SLEEP=${MAX_SLEEP:-600}
DATA_FOLDER=${DATA_FOLDER:-/var/www/html/}

case $1 in
   --dry-run|-dr)
      DR=1
      NOW=1
      ;;
   --now|-n)
      NOW=1
      ;;
esac


while read url; do
   out=$( echo "$url"|md5sum|cut -d " " -f 1 ).json
   echo "Downloading quey to $DATA_FOLDER/$out"
   if ! [[ $DR ]]; then
       wget -q -O "$DATA_FOLDER/$out" "$url"
   fi
   RAND=$(( $RANDOM % $MAX_SLEEP ))
   echo "Sleeping for $RAND seconds between queries"
   if ! [[ $NOW ]]; then
      sleep $RAND
   fi

done<urls.txt
