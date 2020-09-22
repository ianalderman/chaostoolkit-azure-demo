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

1. Once your codepsace has loaded from the menu icon in the top left of the screen select *Terminal -> New Terminal*
2. Due to an issue in our current codespaces setup run the following command (which will enable us to execute the scripts we need): 
`
sudo chmod +x environmentSetup/*.sh
`
3. Now we need to build out the sample Web App (you may be asked to sign in):
`
environmentSetup/buildWebAppDemo.sh
`
4. When the script is complete make note of the Traffic Manager address provided at the end of the script, e.g., `Test URL: http://sfsjkl.trafficmanager.net` - you will need this for configuring your experiments.
5. Test you can connect to the test website in your browser, it should return a very simple *Hello!*

### Experiment Credentials ###

In order to run our experiements we need to configure access for them.

1. Execute the command (you may be asked to sign in): `environmentSetup/configureCredentials.sh`
2. Verify that the credentials file has been created: `less /home/vscode/chaostoolkit-azure-demo/credentials.json`
3. To exit less press `q`

You are good to go!  For completing the Web App Scenario experiments follow the instructions [here](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/experiments/webApps/README.md)

