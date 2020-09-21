#!/bin/bash

# Take the replace string
read -p "Enter the Traffic Manager address (e.g. engasd.trafficmanager.net DO NOT INCLUDE the http://): " replace

search="replaceme"

if [[ $replace != "" ]]; then
#sed -i "s/$search/$replace/" $filename
find . -type f -name "/home/vscode/workspace/chaostoolkit-azure-demo/experiments/webApps/Experiment*" -exec sed -i "s/$search/$replace/g" {} \;
fi
