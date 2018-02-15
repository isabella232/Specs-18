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

- Azure WebApps (_rise my zombie_)
- AWS ElasticBeanstalk
- Azure Functions
- AWS Lambdas
- Kubernetes Cluster

### Current (VM-based) Targets 

_&lt;ThoughtBubble&gt;_ 

As mentioned above, our current targets are really communication channels, rather than targets. We are inferring the target (i.e. Windows, Linux) from the channel (i.e. Tentacle, SSH).

If (when) we release a Tentacle for Linux, or Windows supports SSH, this model suddenly makes less sense. 

We should migrate our existing targets to better reflect the actual target, with the communication channel becoming a property of the target. 

For example, we would have the following targets:

- Windows Server
- Linux Server 

One of the properties of those targets would be _Communication Channel_. You could select:

- Listening Tentacle
- Polling Tentacle
- SSH
- Offline Drop

_&lt;/ThoughtBubble&gt;_ 


### Cloud Regions

The remaining current target is the _Cloud Region_.  A little history...

In Octopus 2.x, there were Azure Cloud Service steps. They ran on Tentacle targets. For some people this was fine, for some it grated that it was required to install a Tentacle to be able to deploy to Azure. 

In Octopus 3.0, targets were introduced for Azure Cloud Services and Azure WebApps. To deploy to Azure you would create a regular _Deploy a Package_ step, and target the new Azure targets. Most people loved this, with the notable exception of those who had previously been dynamically creating their Cloud Services as part of the deployment process.  For these users, the new model didn't work, because there was no way to dynamically add targets to an environment during a deployment. 

So the Azure WebApp and Cloud Service targets were deprecated, and new steps were added: _Deploy an Azure Web App_ and _Deploy an Azure Cloud Service_. These steps did not have targets. The web app/cloud service was configured as part of the step. 

This was fine for most people (though annoying for those who had to change their approach). with the notable exception of people who had been deploying to _multiple_ Azure targets in an environment (e.g. Azure Web Apps in multiple regions). In the 3.0 model this was achieved elegantly by simply applying the same role to all the Azure targets, and then the step could target that role. These people now had to create multiple steps. Many (rightly) argued this was not desirable, especially when dealing with larger numbers of targets.   

And so Cloud Region targets were introduced.  

These served simply as _something_ to iterate over and scope variables to. A for-loop for steps. The difficulty we had naming them was (in hindsight) a bad sign.  They solved the problem, but in a way that was probably a result of the above history more than optimal design. 



