#!/usr/bin/env zsh


filename_to_upload=${1=~/.bash_history}
line_number_to_start_upload=${2=1}
line_number_to_end_upload=${3=100}



## count the total number of lines in file. start
lines_in_filename_to_upload_totally=0
while read line; do
lines_in_filename_to_upload_totally=$((lines_in_filename_to_upload_totally+1))
done < "${filename_to_upload}"
# lines_in_filename_to_upload_totally end


## read and upload line by line. start.
lines_uploaded_counter=0
while read line; do
# reading each line
# echo $line
time_now_unix=$(bashhub util parsedate $(date +"%Y-%m-%dT%H:%M:%S%z"))
bashhub save  $line  ~/ $$ "${time_now_unix}"  0
lines_uploaded_counter=$((lines_uploaded_counter+1))
## rewrite last line in terminal 
echo -e " \e[1A\e[K ${lines_uploaded_counter} of ${lines_in_filename_to_upload_totally} entries imported "
## printf " \e[1A \e[K ${n} of ${lines_in_filename_to_upload_totally} entries imported "
## pause 1s to save some server resource
# sleep 1
done < $filename_to_upload
## read and upload . end


printf " \n ${lines_uploaded_counter} entries imported into bashhub.com \n "


function lines_number_to_upload_selection(){}
function main(){}
main