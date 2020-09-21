# chaostoolkit-azure-demo
A simple demonstration of testing resiliency using Chaos Engineering.

# Scenarios #

## Web App Resiliency Demo ##
The Web App demonstration makes use of [Traffic Manager](https://azure.microsoft.com/en-us/services/traffic-manager/#overview) to provide resiliency against a regional failure.

The high level traffic flow can be seen in the image below:
![Image showing User traffic first hitting Azure Traffic Manager, before before being routed to a Web App in either Region 1 or Region 2](images/high_level_arch.JPG)

A user requests the demo website which is protected by Traffic Manager, based on the routing profile configured the User is directed to the best WebApp instance for them in either Region 1 or Region 2.  In the event that one of the Web Apps is offline the user is automatically routed to the other region.

The environment setup instructions are available here: [Environment setup](https://github.com/ianalderman/chaostoolkit-azure-demo/environmentSetup/README.md) 
Instructions for performing the experiments are here: [Experiment Instructions](https://github.com/ianalderman/chaostoolkit-azure-demo/experiments/webApps/README.md)

