# Demo Environment Setup #

## Web Apps & Traffic Manager Scenario ##

### Codespace setup ###

1. Log in to [Visual Studio Codespaces](https://online.visualstudio.com/login)
2. If this is your first time you will need to create a plan instructions are available [here](https://docs.microsoft.com/en-us/visualstudio/codespaces/quickstarts/browser)
3. When your plan is configured Click *Create Codespace*
4. Name your codespace `Azure Chaos Demo`
5. For *Git Repository* enter `https://github.com/ianalderman/chaostoolkit-azure-demo`
6. For *Instance Type* select *Basic(Linux): 2 cores, 4GB RAM*
7. Click *Create*
8. Your codespace will now need to build the container for use in this demo

### Azure Envrionment setup ###
Our Azure Environment setup creates the following resources:
- [Resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) called *rgDemoPrimaryRegion* which will contain
- - [Web App](https://azure.microsoft.com/en-us/services/app-service/web/) linked to a GitHub repo with a simple "Hello!" page
- - [Traffic Manager](https://azure.microsoft.com/en-us/services/traffic-manager/) Profile for providing resilience to our application
- [Resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) called *rgDemoSecondaryRegion* which will contain:
- - [Web App](https://azure.microsoft.com/en-us/services/app-service/web/) linked to a GitHub repo with a simple "Hello!" page

In order to ensure unique names for the [Traffic Manager](https://azure.microsoft.com/en-us/services/traffic-manager/) profile and the [Web Apps](https://azure.microsoft.com/en-us/services/app-service/web/) the script will generate a unique 6 character string which you will need to make note of as detailed in the steps below - when we come to do the experiments we update the experiment files with this unique string in order to be able to test our site. 

1. Once your codepsace has loaded from the menu icon in the top left of the screen select *Terminal -> New Terminal*
2. Due to an issue in our current codespaces setup run the following command, which will enable us to execute the scripts we need (note it does not produce any output): 
`
sudo chmod +x environmentSetup/*.sh
`
3. Now we need to build out the sample Web App (you may be asked to sign in, please use an account with a valid Azure Subscription for Example MSDN or your organisational subscription):
`
environmentSetup/buildWebAppDemo.sh
`
4. When the script is complete it will provide you with the unique name for your environment - you will need this for configuring your experiments.  It will also provide you with the URL for your [Traffic Manager](https://azure.microsoft.com/en-us/services/traffic-manager/) protected site.
5. Test you can connect to the test website in your browser, it should return a very simple *Hello!*

### Experiment Credentials ###

In order to run our experiements we need to configure access for them.

1. Execute the command (you may be asked to sign in): `environmentSetup/configureCredentials.sh`
2. Verify that the credentials file has been created: `less /home/vscode/chaostoolkit-azure-demo/credentials.json` you should see something along the lines of:  
`
{  
  "clientId": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "subscriptionId": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}  
`
3. To exit less press `q`

You are good to go!  For completing the Web App Scenario experiments follow the instructions [here](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/experiments/webApps/README.md).

**Rembember when you have finished your experiments to delete the resource groups to tidy up your Subscription and bill!**

