# Maintenance Processes #
_Note: The name "`Maintenance Process`" is still up for discussion so don't get hung up on it... ok?_

## TLDR; ##
There exists a need to run a set of steps, similar to a deployment process, but outside the scope of any specific release. These processes need to be able to be run on demand or via some trigger and although they would be lacking any lifecycle progression or snapshotting, there would still be a need for some variables and environment scoping.

## User Requests ##
[UserVoice #17696959 - Crete jobs for recurring tasks (6 votes)](https://octopusdeploy.uservoice.com/forums/170787-general/suggestions/17696959-create-jobs-for-recurring-tasks-use-permissions-t)

[UserVoice #6905729 - Support Tasks on the tentacles (2 votes)](https://octopusdeploy.uservoice.com/forums/170787-general/suggestions/6905729-support-task-on-the-tentacles)

## User Stories ##
* I as a _DBA_ want to be able to _configure a backup process for my production database to run once a day_ so that I can _leverage my existing Octopus information to determine where these databases are and where the backups should go_.
* I as a _project manager_ want to be able to _update a website's certificate when they are close to expiry_ so that _they experience no downtime and can be integrated into Octopus Deploy's certificate management_.
* I as _Paul Stovell_ want to be able to _run a DocuSync executable daily, somewhere in my infrastructure_ so that I _dont need to rely on TeamCity_.
* I as a _test lead_ want to be able to _run a provisioning\deprovisioning script to spin up an entirely new environment on demand when a new tester joins my team_ so that _a project can be automatically confiured to include that environment and it's targets into its lifecycle_. 
* I as a _project manager_ want to be able to _configure a health check ping against my deployed projects_ so that the I can use Octopus' knowlege of different environment endpoints to know where to call, as well as flag in Octopus itself when there are problems to be automatically mitigated_.

## Design ##
##### No Snapshots #####
Apart from having processes and variables, maintenance processes and projects are a different beast. Maintenance processes have no lifecycle, so they can be executed to any environment at any time without regard for previous executions. Since there is no specific release, it also makes sense that there need be no channels either. As a result of this, there is also no conept of snapshotting. The execution uses the current values available to that process at the time that it runs. This includes tasks that are scheduled to occur at a later date or on a schedule. Snapshotting makes sense in the project world, where your aim is repeated deployments of some artifacts (or scripts) that must incrimentally complete a controlled progression through a defined life cycle. Maintenance processes exist and run as independent one-off tasks. If existing schedules need to continue untouched while at the same time running a newer process, the lightweight design of maintenance processes means you can just clone and edit a whole new process. If this is still not enough, it may be that what you really want is a project, you just don't know it :) .

##### Context #####
A maintenance processes lives outside and at the same level as projects (eventually at the `Space` level). Although it was considered that they could live _additionally_ within a project (so a project can have its own maintenance tasks), this adds unecessary complexity considering we would still want project-less maintenance processes that can be avoided by managing them all in one place. Since the end goal of `Spaces` should provide better oganisation of project ownership, this level should provide a good balance between ending up with a dumping ground of processes, and being actually relevant to the people who need them.


#### Proces Screen ####

## Vision Fit ##
### Octopus as Enterprise ###
n/a

### Octopus as Cloud-First ###
Maintenance processes are a piece that lays the groundwork for the development of `Transient Environments`. In order to provied the ability to provision/deprovision entire environments on-the-fly, it is through the invocation of maintenance processes that might involve steps like an `AWS CloudFormation` setp type to set up the new infrastructure. 

### Octopus as Hosted ###
n/a
