primaryRG=rgDemoPrimaryRegion
secondaryRG=rgDemoSecondaryRegion
primaryAppNamePrefix=learningDayRegion1WebApp-
secondaryAppNamePrefix=learningDayRegion2WebApp-
uniquename=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6 ; echo '')

primaryAppName=$primaryAppNamePrefix$uniquename
secondaryAppName=$secondaryAppNamePrefix$uniquename

az login
#Create Resource Group
az group create --name $primaryRG --location northeurope
#create App Service Plan
az appservice plan create -n MyPlan -g $primaryRG --sku S1
#Create a Web App and link to GitHub Repo

az webapp create -g $primaryRG -p MyPlan -n $primaryAppName --runtime "node|10.14" --deployment-source-url https://github.com/ianalderman/helloworldnodejs


az network traffic-manager profile create -g $primaryRG -n MyTmProfile --routing-method Performance \
    --unique-dns-name $uniquename --ttl 30 --protocol HTTP --port 80 --path "/"

MyWebApp1Id=$(az webapp show -g $primaryRG -n $primaryAppName --query [id] --output tsv)

az network traffic-manager endpoint create -g $primaryRG --profile-name MyTmProfile \
    -n Region1EndPoint --type azureEndpoints --target-resource-id $MyWebApp1Id --endpoint-status enabled

#Create Resource Group
az group create --name $secondaryRG --location westeurope
#create App Service Plan
az appservice plan create -n MyPlan -g $secondaryRG --sku S1
#Create a Web App and link to GitHub Repo
az webapp create -g $secondaryRG -p MyPlan -n $secondaryAppName --runtime "node|10.14" --deployment-source-url https://github.com/ianalderman/helloworldnodejs

MyWebApp2Id=$(az webapp show -g $secondaryRG -n $secondaryAppName --query [id] --output tsv)

az network traffic-manager endpoint create -g $primaryRG --profile-name MyTmProfile \
    -n Region2EndPoint --type azureEndpoints --target-resource-id $MyWebApp2Id --endpoint-status enabled

echo "Make a note of the following unique name you will be asked for it for configuring your experiments: ${uniquename}"
echo "Test URL: http://${uniquename}.trafficmanager.net"