# Run Experiments #

## Configure WebApp Experiments ###
Before we can run our experiments we need to update our WebApp experiments with the unique name assigned to our website for this demo.  In the [*Environment setup*](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/environmentSetup/README.md) stage you should have made note of your traffic manager address.

1. Change to the *experiments/webApps* directory.  In the contianer: `cd ~/chaostoolkit-azure-demo/experiments/webApps`
2. Due to an issue in our current codespaces setup run the following command (which will enable us to execute the scripts we need): 
`sudo chmod +x *.sh`
3. Execute the *configureExperiments.sh* script.  In the container: `./configureExperiments.sh`
4. At the prompt enter the Traffic manager address from the [*Environment setup*](https://github.com/ianalderman/chaostoolkit-azure-demo/blob/master/environmentSetup/README.md) steps.  **N.B DO NOT INCLUDE THE HTTP://**, e.g., for **http://example.trafficmanger.net** enter `example`
5. Let's check that the script has updated as we would expect.  Type `less Experiment1.json`, you should see a `probe` called *we-can-request-hello-world-site* and under that you should see `"url":"..` that hopefully has your traffic manager address.  You may need to press *space bar* to scroll down.  Again press *q* to quit

## Test our hypotheses ##
Now it is time to test our hypotheses and inject some chaos into our system!

*These commands should be executed from the *experiments/webApps* directory (you should still be here from previous steps)*

1. We need to switch to our testing environment run the following command: `source /home/vscode/venvs/chaostk/bin/activate`

*N.B. In testing we noted rare instances where the steady state probe fails to connect to the website, disabling and re-enabling the Traffic Manager Profile fixed this*

### Experiment 1 ###
In our first experiment we will stop the Web App running in Region 1 and confirm that the website behind Traffic Manager still works.  Execute the command below to run the experiment: `chaos run Experiment1.json`

As the experiment runs you should see what is referred to as the *Journal* output, the first thing we do is check that the *Steady state hypothesis* is true **before** we break anything.  In our case we are testing that the test site is indeed available, for this we use a *Probe* which tests the address you supplied to the earlier script.  

Assuming that is successful we then move on to introducing some chaos into our system via an *action* which stops the Web App in Region 1.  Once we have completed our actions we once again test the steady-state to make sure it all still works...

### Experiment 2 ###
In our second experiment we will stop the Web App running in Region 2 and confirm that the website behind Traffic Manager still works.  Execute the command below to run the experiment: `chaos run Experiment2.json`

### Experiment 3 ###
In our second experiment we will stop the Web App running in both Regions 1 & 2 and confirm that the website behind Traffic Manager is no longer available.  Execute the command below to run the experiment: `chaos run Experiment3.json`

*N.B. This experiment should fail - we have taken both regions offline*



