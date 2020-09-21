# Run Experiments #

## Configure WebApp Experiments ###
Before we can run our experiments we need to update our WebApp experiments with the unique name assigned to our website for this demo.  In the [*Environment setup*](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/environmentSetup/README.md) stage you should have made note of your traffic manager address.

1. Change to the *experiments/webApps* directory.  In the contianer: `cd ~/chaostoolkit-azure-demo/experiments/webApps`
2. Due to an issue in our current codespaces setup run the following command (which will enable us to execute the scripts we need): 
`sudo chmod +x *.sh`
3. Execute the *configureExperiments.sh* script.  In the container: `./configureExperiments.sh`
4. At the prompt enter the Traffic manager address from the [*Environment setup*](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/environmentSetup/README.md) steps.  **N.B DO NOT INCLUDE THE HTTP://**, e.g., for **http://example.trafficmanger.net** enter `example.trafficmanager.net`

## Test our hypotheses ##
Now it is time to test our hypotheses and inject some chaos into our system!

*These commands should be executed from the *experiments/webApps* directory (you should still be here from previous steps)*

1. We need to switch to our testing environment run the following command: `source /home/vscode/venvs/chaosk/bin/activate`

### Experiment 1 ###
In our first experiment we will stop the Web App running in Region 1 and confirm that the website behind Traffic Manager still works.  Execute the command below to run the experiment: `chaos run Experiment1.json`

### Experiment 2 ###
In our second experiment we will stop the Web App running in Region 2 and confirm that the website behind Traffic Manager still works.  Execute the command below to run the experiment: `chaos run Experiment2.json`



