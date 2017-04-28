#!/bin/bash
##    Alejandro Suarez Cebrian (Coordinador del grupo de Mapeado Colaborativo)
##    Hector Ochoa Ortiz (Coordinador del grupo de Mapeado Colaborativo)
##    Copyright (C) 2017  Alejandro Suarez Cebrian
##    Copyright (C) 2017  Hector Ochoa Ortiz
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

# Exit on errors and unset variables
set -e
set -u

PID=$$

log () {
   echo "$(date --rfc-3339=seconds) [$PID] $@"
}


BASEDIR=$(dirname "$0")
source ${BASEDIR}/config.sh

MAX_SLEEP=${MAX_SLEEP:-600}
DATA_FOLDER=${DATA_FOLDER:-/var/www/html/}
LOGFILE=${LOGFILE:-umap-overpass-cacher.log}
DR=0
NOW=0

case $1 in
   --dry-run|-dr)
      DR=1
      NOW=1
      ;;
   --now|-n)
      NOW=1
      ;;
   *)
      DR=0
      NOW=0
      ;;
esac

if ! [[ $DR -eq 1 ]]; then
   # Log all activity to file.
   exec >> $LOGFILE 2>&1
   trap 'savelog -c 28 -n $LOGFILE > /dev/null' EXIT
fi

while read url; do
   if [[ $DR -eq 1 ]]; then
      log "Starting whith query $url" 
   fi
   out=$( echo "$url"|md5sum|cut -d " " -f 1 ).json
   log "Downloading query to $DATA_FOLDER/$out"
   if ! [[ $DR -eq 1 ]]; then
       wget -q -O "$DATA_FOLDER/$out" "$url"
   fi
   RAND=$(( $RANDOM % $MAX_SLEEP ))
   log "Sleeping for $RAND seconds between queries"
   if ! [[ $NOW -eq 1 ]]; then
      sleep $RAND
   fi

done<${BASEDIR}/urls.txt
