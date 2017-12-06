# [Resources](index.md) #
## Extensibility ##
Abstracting the resource out of the step, may provide a good opportunity to start to consider how we plan to provide a plugable model to the deployment steps.
There are essentially 3 parts to any deployment step. 
1. The UI configuration screen
2. _Occasionally_ some server endpoints for loading supporting information, e.g. Loading Azure resources for UI drop downs.
3. The Calamari code that actually performs the step execution.

