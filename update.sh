#!/bin/bash

# update #

scripts_list=(
	models-sync.sh
	models-pages.sh
)

for script in ${scripts_list[@]}
do
	bash ${script}
done

# upload changes

git add *

git commit -a -m 'Models update'

git push