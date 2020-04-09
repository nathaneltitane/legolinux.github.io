#!/bin/bash

shopt -s extglob

# models sync #

# variables #

cloud="/media/MEGA"
root="$PWD/models"

local_models_directory="$cloud/Lego/models"
server_models_directory="$PWD/models"

source_uid_file="$cloud/Lego/sketchfab/uid-list"
destination_uid_file="$root/uid-list"

# models #

# check if directory exists

if [ -d "$server_models_directory" ]
then
	cd "$server_models_directory" || exit

	rm -rf !(*.html|*.sh)
else
	mkdir -p "$server_models_directory"
fi

# synchronize #

rsync -avr \
	--exclude='*.ldr' \
	--exclude='*.mpd' \
		$local_models_directory/* $server_models_directory

# create indexes

cd "$server_models_directory" || exit

for directory in $(find $server_models_directory -maxdepth 0 -type d)
do
	echo "$directory"

	cd "$directory" || exit

	# create model title file

	echo "$(basename $directory)" | sed -e "s/\b\(.\)/\u\1/g" -e "s/-/ /g"  > title

	for subdirectory in $(find $server_models_directory/* -maxdepth 1 -type d)
	do
		echo "$subdirectory"

		cd "$subdirectory" || exit

		# create model title file

		echo "$(basename $subdirectory)" | sed -e "s/\b\(.\)/\u\1/g" -e 's/\(.*\)/\U\1/'  > title

	done

	# exit to top level

	cd "$server_models_directory" || exit
done

# background #

# check if directory exists

if [ -d "../background" ]
then
	rm -rf "../background"
	mkdir -p "../background"

else
	mkdir -p "../background"
fi

extensions_list=(
    png
)

for extension in ${extensions_list[@]}
do
    # copy flat renders into background directory

    count=0

    for background in $(echo $(find $local_models_directory -type f -iname flat.$extension))
    do
        if [[ $count =< "99" ]]
        then
            count_prefix="-0"
        fi

        rsync -avr "$background" "../background/background${count_prefix}${count}.png"

        ((count++))


        echo
        echo $count
    done

    # update random background generator with new file count

	cat <<- FILE > ../javascript/set-random-background.js
		// set random background //

		\$(document).ready(function() {
		var count = $count;

		function pad(str, max) {
			str = str.toString();
			return str.length < max ? pad("0" + str, max) : str;
		}

		\$('.background').css(
			'background-image',
			'url("/background/background-' + pad(Math.floor(Math.random() * count), 3) + '.png ")'
		);
		});
	FILE

done
