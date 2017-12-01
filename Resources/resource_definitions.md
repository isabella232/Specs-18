# Resources #
## Resource Definitions ##
Some actions require resources that match a specific interface\shape. e.g. Azure steps require resources that include accounts but an "Deploy a package" step just requires somewhere that packages can be extracted to. So each step defines what resource is required. 

A resource definition may be built-in to Octopus, or provided via the step extension package (at some later point). This definition would include 
- The name
- A list of any required rules (e.g. the base AWS resource may require an AWS credential to always be provided) 
- A reference to any other resources that it extends (e.g. the AWS S3 resource may extend the AWS resource to includes the AWS credential requirements) 
- An icon

When looking at the [resource rules](resource_rules.md) for a given resource type, you can see how the Azure resources require the presence of a specific account type which can be hard-coded to a specific value, differ between environments or use use variable substitution to resolve to a value. Accounts, Certificates and other similar entities in Octopus can be considered as `typed-variables` to make selection and configuration as simple and safe as possible.
![Rule Definition Azure](rule_definition_azure.png)

Each step then references the resource required for its execution. Since resource definitions feature a form of inheritance or decorators, you can use a resource, with rules provided from another step, in a step that just requires the supertype. E.g, you may have an IIS step which requires an IIS resource, but then a subsequent step where you just want to run some code on that target, you can jut select the same IIS resource to ensure that all machines that run step 1 will also run step 2.

It may possibly even make sense for some steps to support multiple resource types if it has the right deployment code to handle that. For example we may want to provide a step that is just called "Deploy Website" which can take either an IIS resource or an Azure Web App resource and it performs the appropriate deployment depending on the resource supplied. This would be a nice solution for those cases where the user wants to, say deploy staging locally but deploy production to the cloud but this may require additional abilities to supply the relevant variables required for each of the steps, given different step logic (e.g. IIS steps require binding information while Azure Web Apps do not). For this reason I'm a little unsure if this is a good idea.