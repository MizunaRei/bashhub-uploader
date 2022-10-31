#!/usr/bin/env zsh


filename_to_upload=${1=~/.bash_history}
line_number_to_start_upload=${2=1}
line_number_to_end_upload=${3=100}
lines_to_upload=0
## for debug
 	## printf " filename $filename_to_upload . line start $line_number_to_start_upload . line end $line_number_to_end_upload . " 


if [  -e "$(which bashhub)" ]; then
		## greetings
	 printf " \n Welcome. This script could help you with \n uploading command line history from local dotfiles to bashhub.com server. \n \n "

	else
	printf " \n We could not find bashhub executable file.  \n For setting up shell plugins we recommend this project. \n  \n https://github.com/MilkyMAISHIRANUI/unix_shell_plugins_setup \n \n " 
exit 1
	fi

function upload_to_bashhub(){
## read and upload line by line. start.
## for reading easily
printf " \n \n "
line_number_being_uploaded=0
lines_uploaded_counter=0

# read file in while loop . start .
while read line; do
# reading each line
# echo $line
line_number_being_uploaded=$((line_number_being_uploaded+1))

## upload from specific line number
if   [  $line_number_being_uploaded -ge   $line_number_to_start_upload   ] 
 then
	time_now_unix=$(bashhub util parsedate $(date +"%Y-%m-%dT%H:%M:%S%z"))
	bashhub save  ' $line '  ~/ $$ "${time_now_unix}"  0
	lines_uploaded_counter=$((lines_uploaded_counter+1))
	## rewrite last line in terminal 
	printf  "\e[1A\e[KLine $line_number_being_uploaded was uploaded. ${lines_uploaded_counter} of ${lines_to_upload} entries imported "
## piintf does not work
## echo -e works
## printf " \e[1A \e[K ${n} of ${lines_in_filename_to_upload_totally} entries imported "
fi

## stop upload till specific line number
if   [  $line_number_being_uploaded  -ge  $line_number_to_end_upload ] 
 then
	break
fi

## pause 1s because Bashhub.com they have a rate limit of 10 requests a seconds and you are limited to your last 10,000 commands.
sleep 1

## read file in while loop. end.
done < $filename_to_upload

printf " \n  "
## read and upload line by line . end
}



function count_lines_to_upload(){

if (( $line_number_to_start_upload < $line_number_to_end_upload -98  )) 
then
## for debug
 	## printf  " line start $line_number_to_start_upload < line end $line_number_to_end_upload - 98 "
line_number_to_end_upload=$((line_number_to_start_upload+99))
fi

if (( $line_number_to_start_upload > $line_number_to_end_upload   )) 
 then
line_number_to_end_upload=$((line_number_to_start_upload+99))
fi
lines_to_upload=$((line_number_to_end_upload - line_number_to_start_upload +1))
printf  " \n Bashhub.com they have a rate limit of 10 requests a seconds \n and you are limited to your last 10,000 commands. \n We will upload from line $line_number_to_start_upload to line $line_number_to_end_upload or to the end of file. \n "

}


function count_lines_in_filename_to_upload_totally(){
	## count the total number of lines in file. start
lines_in_filename_to_upload_totally=0
while read line; do
lines_in_filename_to_upload_totally=$((lines_in_filename_to_upload_totally+1))
done < "${filename_to_upload}"
printf " \n $lines_in_filename_to_upload_totally entries in file $filename_to_upload . \n  \n "
# lines_in_filename_to_upload_totally end
}



function main(){
count_lines_in_filename_to_upload_totally
count_lines_to_upload
upload_to_bashhub
printf " \n   ${lines_uploaded_counter} entries imported into bashhub.com \n "
exit 0
}


## call main function as in C language
main
