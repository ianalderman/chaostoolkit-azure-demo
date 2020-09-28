#!/bin/bash

# Take the replace string
read -p "Enter the unique name that was generated for these experiments (e.g. http://adjalj.trafficmanager.net would be adjalj): " replace

search="replaceme"

if [[ $replace != "" ]]; then
#sed -i "s/$search/$replace/" $filename
find . -type f -name "Experiment*" -exec sed -i "s/$search/$replace/g" {} \;
fi
