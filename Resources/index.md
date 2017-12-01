# Resources #
As Octopus looks to better support  a cloud-first approach, the way in which we view the relationship between tentacles and deployments could do with an update.

## What Is A Resource ##
Resources can be considered in some sense as the conceptual target for the deployment. That is to say it is the intended location where we want the deployment to affect something in the world. That could be a Tentacle located on some on-prem infrastructure, or it could be a cloud service like an Azure Web App. What defines a resource is a set of rules that describe the required tags that should be present for that destination to be considered as part of the deployment. Some resources will have additional required information that is associated with that resource. For example a SQL database resource may have the additional requirement for a connection string and any Azure-based resource (like a Service-Fabric Cluster) would require, at a minimum, an Azure account credential. These values may be hard-coded in the rules, or derived via some basic variable substitution to allow dynamic resolution at runtime. 

When defining an action, the target is currently (as of 4.0) defined by one (or more) `roles`. When defining an azure deployment, the target is currently defined using `Azure Credentials` along with potentially a `Web App Name` (for deploying web apps), `Storage Account` (for deploying cloud services) or any other number of properties which are more about defining _Where_ you want the deployment to take place as opposed to the _How_ (which more closely corresponds to the variables, configuration, scripts or Calamari conventions of the action). The resource defines the _Where_ part of the deployment and by modelling them as a separate concept, it provides a way that better fits a dynamic world where machines (or external items) may come and go on the fly and you want to be able to reason about the state of your application outside the context of a specific active deployment task.

By looking at deployments in this way we can see that a deployment, as described above, can be seen as utilizing a bunch of resources to perform some task. Defining these resources outside of the step itself will make it easier to define the properties that change between environments, as well as providing a first class way of representing to the user their presence instead of through some combination of arbitrary properties in a step.

So if a resource is considered an abstract representation of _Where_, an specific Tentacle or Server that meets the required rules can be considered concrete instance of that resource.

## Further Reading ##
### [Resource Rules](resource_rules.md) ###
### [Holistic App View](holistic_view.md) ###
### [Resource Definitions](resource_definitions.md) ###
### [Resource Health Checks](resource_health_checks.md) ###
### [Permissions/Auth](permissions.md) ###
### [Migration](migration.md) ###