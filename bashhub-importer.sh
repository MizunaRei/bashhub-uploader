#!/usr/bin/env zsh

filename=$1
export unixtimenow
export linescounter


## count the total number of lines in file. start
linescounter=0
while read line; do
linescounter=$((linescounter+1))
done < $filename
# linescounter end


## read and upload line by line. start.
n=0
while read line; do
# reading each line
# echo $line
unixtimenow=$(bashhub util parsedate $(date +"%Y-%m-%dT%H:%M:%S%z"))
bashhub save "${line}" ~/ "$$" "${unixtimenow}"  0
n=$((n+1))
echo -e " \e[1A\e[K ${n} of ${linescounter} entries imported "
## printf " \e[1A \e[K ${n} of ${linescounter} entries imported "
## pause 1s to save some server resource
# sleep 1
done < $filename
## read and upload . end


printf " \n ${n} entries imported into bashhub.com \n "
