primaryRG=rgDemoPrimaryRegion
secondaryRG=rgDemoSecondaryRegion
primaryAppNamePrefix=learningDayRegion1WebApp-
secondaryAppNamePrefix=learningDayRegion2WebApp-
uniquename=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6 ; echo '')

primaryAppName=$primaryAppNamePrefix$uniquename
secondaryAppName=$secondaryAppNamePrefix$uniquename
afdName="${uniquename}"

az login

accountCount=$(az account list --query '[].{subscriptionId:id}' --output tsv | wc -l)

if [ $accountCount -gt 1 ] 
    then
        read -p "You appear to have access to multiple accounts.  We will now list out your accounts, at the next prompt please enter the index for the account you wish to use.  Press any key to continue..." 
        found="false"
        until [ $found = "true" ]; do
            az account list --query '[].{subscriptionName:name, subscriptionId:id}' --output table
            read -p "Please enter the index of your required subscription (e.g., 1):" subIndex

            index=$(expr $subIndex - 1)
            az account list --query "[${index}].{subscriptionName:name, subscriptionId:id}" --output table
            read -p "Is this the correct subscription? Y(es) or N(o) or Q(uit): " yn
            case $yn in
                [Yy] ) az account set -s $(az account list --query "[${index}].[id]" --output tsv); echo "Account selected"; break;;
                [Qq] ) exit;;
                *) found="false";;
            esac
        done 
fi

#Create Resource Group
az group create --name $primaryRG --location northeurope
#create App Service Plan
az appservice plan create -n MyPlan -g $primaryRG --sku S1
#Create a Web App and link to GitHub Repo

az webapp create -g $primaryRG -p MyPlan -n $primaryAppName --runtime "node|10.14" --deployment-source-url https://github.com/ianalderman/helloworldnodejs

MyWebApp1Id=$(az webapp show -g $primaryRG -n $primaryAppName --query [id] --output tsv)

#Create Resource Group
az group create --name $secondaryRG --location westeurope
#create App Service Plan
az appservice plan create -n MyPlan -g $secondaryRG --sku S1
#Create a Web App and link to GitHub Repo
az webapp create -g $secondaryRG -p MyPlan -n $secondaryAppName --runtime "node|10.14" --deployment-source-url https://github.com/ianalderman/helloworldnodejs

MyWebApp2Id=$(az webapp show -g $secondaryRG -n $secondaryAppName --query [id] --output tsv)

# ----------------- Front Door ---------------------------------
#https://github.com/MikeWedderburn-Clarke/AzL200/blob/master/Networking/AzureNetworking101.azcli

# The latest Azure Front Door extensions may need to be added to your Cloud Shell instance
az extension add --name front-door

# Create AFD
az network front-door create -g $primaryRG -n $afdName --backend-address "${primaryAppName}.azurewebsites.net" --interval 5 --protocol http 

# Update Load Balancing rule for AFD to fail-over quicker and set the latency threshold to high enough so it will use both back-ends
az network front-door load-balancing create -g $primaryRG -f $afdName -n DefaultLoadBalancingSettings --sample-size 1 --successful-samples-required 1 --additional-latency 2000

# Add the 2nd Region to the back-end pool 
az network front-door backend-pool backend add -g $primaryRG -f $afdName --pool-name DefaultBackendPool --address "${secondaryAppName}.azurewebsites.net"

#Configure Credential file
az ad sp create-for-rbac --sdk-auth > /home/vscode/chaostoolkit-azure-demo/credentials.json

echo "Make a note of the following unique name you will be asked for it for configuring your experiments: ${uniquename}"
echo "Test URL: http://${uniquename}.azurefd.net"

