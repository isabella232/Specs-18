Octopus is a _dedicated_ release\deployment tool.  Our domain model reflects this: Releases, Deployments, Environments, and _Targets_ (aka machines).

Originally, Tentacle (i.e. a Windows machine running the Tentacle agent) was the only target type. Over time targets have been added and removed (e.g. FTP, Azure CloudServices).  

The current (as of 02/2018) target list is:

- Listening Tentacle
- Polling Tentacle
- SSH
- Offline Drop
- Cloud Region

An interesting observation is that the current list is more about the _communication channel_ than it is about the destination. But we currently make some implicit assumptions, i.e. that Tentacles == Windows, SSH == Linux.  It seems likely that these assumptions will not always hold. 

## PaaS 

_[The Cloud enters stage left]_

The world is changing.  More and more, a deployment is not targetting a group of machines, but rather a platform-as-a-service endpoint such as an Azure WebApp or an AWS ElasticBeanstalk. 

This brings us to a cross-roads. 

### Option A: Variables

For a deployment step targetting a PaaS endpoint, we could consider the target to be simply a configuration value of the step (possibly bound to a variable). This is the way we currently implement Azure WebApp and CloudService steps, and is the way, for example, VSTS implements this. 

### Option B: Targets

Alternatively, we can model these as targets, which live in one or more environments and have their own self-contained set of properties.

We are opting for _Option B: Targets_.  

_Why?_  

Because this plays to Octopus's strengths. We model environments as first-class entities which contain targets (this is a surprisingly rare approach among our competitors).  We believe this matches how users think about environments and targets. It provides a natural way for a step to target different instances for different environments, and multiple instances (via roles).  The user explicitly modelling in Octopus their environment\target relationships also opens many possible feature-directions, for example: 

- operations processes which execute against an environment (running custom health-check processes, or a database backup task) 
- custom status\diagnostic pages for targets (which pods are running on my Kubernetes cluster?)
- Dynamic environments!!  


## Target Zoology

Which targets will we have?

Natural fits from the Paas world would seem to be:

- Azure WebApps (rise my zombie)
- AWS ElasticBeanstalk
- Azure Functions
- AWS Lambdas
- Kubernetes Cluster


### Custom Targets

