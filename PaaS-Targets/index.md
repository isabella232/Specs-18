Octopus is a dedicated release\deployment tool.  Our domain model reflects this: Releases, Deployments, Environments, and _Targets_ (aka machines).

Originally, Tentacle (i.e. a Windows machine running the Tentacle agent) was the only target type. Over time targets have been added and removed (e.g. FTP, Azure CloudServices).  

The current (as of 02/2018) target list is:

- Listening Tentacle
- Polling Tentacle
- SSH
- Offline Drop
- Cloud Region

With the exception of Cloud Region, these targets all represent connections to Windows or Linux machines (indirectly in the case of Offline Drop).

## PaaS 

_[The Cloud enters stage left]_

The world is changing.  More and more, a deployment is not targeting a group of machines, but rather a platform-as-a-service endpoint such as an Azure WebApp or an AWS ElasticBeanstalk. 

This brings us to a cross-roads. 

### Option A: Variables

For a deployment step targeting a PaaS endpoint, we could consider the target to be simply a configuration value of the step (possibly bound to a variable). This is the way we currently implement Azure WebApp and CloudService steps, and is the way, for example, VSTS implements this. 

### Option B: Targets

Alternatively, we can model these as targets, which live in one or more environments and have their own self-contained set of properties.

We are opting for _Option B: Targets_.  

## Why Targets and not Variables?

One of the key abilities that targets in Octopus provide is allowing a step to specify a role, and it will then be executed once for each target matching that role.  
The thing is, that ability is generally not required when deploying to PaaS endpoints. There is often only one instance of a PaaS endpoint in each environment (e.g. one Azure Web App, one ElasticBeanstalk, etc).  This could be just as easily achieved by the step deploying to a configured variable.

_So why do we have targets?  Why not make everything a variable?_

Because this plays to Octopus's strengths. We model environments as first-class entities which contain targets (this is a surprisingly rare approach among our competitors).  We believe this matches how users think about environments and targets.  And it still nicely handles those scnearios where you _do_ want to target multiple instances (via roles).  

### Putting the Ops in DevOps

By allowing users to explicitly model their targets as self-contained objects which live in environments, Octopus has valuable information and concepts that wouldn't exist if targets existed only as configuration values dispersed throughout deployment processes.  This opens many possible feature-directions, for example: 

- operations processes which execute against an environment (running custom health-check processes, or a database backup task) 
- custom status\diagnostic pages for targets (which pods are running on my Kubernetes cluster?)
- Dynamic environments!!  

### The Almighty $$$

The Octopus licensing model is machine-based: the more machines you deploy to, the more you pay.

Currently, only Tentacle and SSH targets are counted for licensing.  Obviously as the adoption of PaaS offerings increases, this would result in Octopus collecting less in licensing.

By introducing dedicated PaaS targets, this provides the opportunity to include them in the licensing model.  The move from machines to PaaS targets will have some snakes and some ladders (in some ways it will reduce the licensing-count, in others it may increase it):  

- Snake: A customer who today deploys to a web application to a cluster of machines pays per machine.  In a PaaS world, they may deploy to only a single ElasticBeanstalk or Azure Web App instance (because they scale 'internally').

- Ladder: A customer who today deploys multiple web applications and services to a single machine may deploy them to multiple PaaS targets in the future. The PaaS model encourages a more fine-grained hosting approach.

How these opposing forces will balance is the question.

### So where is the line between a target and a variable? 

Unless you are dealing with multiple targets in the same role, the line between targets and variables is somewhat arbitrary.  When adding new features, how do we decide?

I think this is a situation where your first instinct is probably correct. If it feels like a target, it probably is. But as a rule of thumb, if the following sentence makes sense:

_Target X has version Y of a project in environment Z_ 

then it is likely a target.  As an example, should Azure Resource Groups be targets?  The sentence above does not make sense for a resource group.  And a resource group doesn't _feel_ like a target.  So they should be implemented as variables.


## Target Zoology

Which targets will we have?

Natural fits from the Paas world would seem to be:

- Azure WebApps (_rise my zombie_)
- AWS ElasticBeanstalk
- Azure Functions
- AWS Lambdas
- Kubernetes Cluster

### Current (VM-based) Targets 

An interesting observation is that the current targets (with the exception of Cloud Regions) are more about the _communication channel_ than about the destination. We currently make some implicit assumptions, i.e. that Tentacles == Windows, SSH == Linux.  It seems almost certain that these assumptions will not always hold. 

If (when) we release a Tentacle for Linux, or Windows supports SSH, this relationship breaks down. We will need to consider how best to model this in the future.

But for the moment at least, the existing targets will remain as is. Well, with the possible exception of Cloud Regions.

### Cloud Regions

The remaining current target is the _Cloud Region_.  A little history...

_Feel free to skip the following, but it sometimes helps to know how we got to where we are._

In Octopus 2.x, there were Azure Cloud Service steps. They ran on Tentacle targets. For some people this was fine, for some it grated that it was required to install a Tentacle to be able to deploy to Azure. 

In Octopus 3.0, targets were introduced for Azure Cloud Services and Azure WebApps. To deploy to Azure you would create a regular _Deploy a Package_ step, and target the new Azure targets. Most people loved this, with the notable exception of those who had previously been dynamically creating their Cloud Services as part of the deployment process.  For these users, the new model didn't work, because there was no way to dynamically add targets to an environment during a deployment. 

So the Azure WebApp and Cloud Service targets were deprecated, and new steps were added: _Deploy an Azure Web App_ and _Deploy an Azure Cloud Service_. These steps did not have targets. The web app/cloud service was configured as part of the step. 

This was also fine for most people (though annoying for those who had to change their approach). with the notable exception of people who had been deploying to _multiple_ Azure targets in an environment (e.g. Azure Web Apps in multiple regions). In the 3.0 model this was achieved elegantly by simply applying the same role to all the Azure targets, and then the step could target that role. These people now had to create multiple steps. Many (rightly) argued this was not desirable, especially when dealing with larger numbers of targets.   

And so Cloud Region targets were introduced.  

These served simply as _something_ to iterate over and scope variables to. A for-loop for steps. The difficulty we had naming them was, in hindsight, a bad sign.  They solved the problem, but in a way that was perhaps a result of the above history more than optimal design. 

Reintroducing Azure targets probably removes the need for Cloud Regions for the majority of the current usage scenarios. But we can't guarantee that customers aren't using them in a way which couldn't be replaced by the new PaaS targets.  

Which leaves us with three options:

1. Leave Cloud Regions as is.
2. Gracefully deprecate them.  e.g. Make creating new Cloud Regions non-obvious, then eventually impossible, and see if anyone complains.
3. Replace Cloud Regions with the more generic custom targets.

For now, we are taking option 2.  We will obviously keep them working, but de-prioritize them in the UI wherever possible. 


### Custom Targets

The idea behind Custom Targets is that they would allow the user to create a custom target type.  These will be able to define property templates and a custom icon. 

These would perform a similar role to Cloud Regions, but hopefully with a better user-experience.

The question is, is there a need?



## Targets and Accounts

A common feature of every PaaS target is they require account details for authentication (i.e. AWS or Azure subscription). When deploying to the targets, it doesn't make sense to configure the account again in the steps.  Steps which deploy to these targets will use the account configured on the target. 

### Script Steps

For AWS and Azure Script Steps, there will be the an option to use the account from a variable, or to use the account from targets (when running on behalf of roles).


