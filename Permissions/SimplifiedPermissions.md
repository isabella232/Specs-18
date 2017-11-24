We want to simplify permissions in Octopus. Goals:

 - For customers, it should be easy to reason about what permissions someone has when using Octopus
 - It should be possible to delegate some level of ownership for permissions
 
Right now Octopus uses the following:

 - Permission - an enum of things that can be done (`ProjectView`, `DeploymentCreate`)
 - Role - a group of common permissions ("Project viewer: has `ProjectView` and `EnvironmentView` permissions")
 - Team - assigns roles to people, and optionally scope the permissions of that role to a project group/project/environment/tenant (whoa!)

The last part gets messy because people need multiple teams to represent different roles. For example, if your rules were:

 - Testers can deploy any project to the Test environment
 - Testers can view production deployments
 
You would need two "Teams" in Octopus to model this currently, which doesn't align with how people would expect it to work. 

# New model

*Note*: This is assuming [Spaces](../Spaces/index.md) have been implemented.

## 1. Nothing by default
We assume that nobody has permission to do anything (like now) unless granted that permission explicitly. 

## 2. Groups
We'll introduce "groups", which are collections of users or map to external security groups (AD groups). "Octopus Administrators" and "Everyone" become built in groups. Unlike "teams", a group is just a collection of people - it defines nothing about what those people can do. 

## 3. View everything
If you have permission to view a Space then you have permission to view _everything_ within that Space. This includes Projects, Environments, Variables (of course not sensitive ones), Releases, Deployments. There will no longer be individual View permissions


## 4. Per-Object Permissions
Instead of a global set of teams, we allow certain classes of objects to have permissions granted directly on them. It's similiar to how Windows allows you to set permissions on individual files/directories rather than some big global permission system. 

- Octopus server as a whole
- Space 
- Project
- Environment
 
In the UI, this will appear as a button to edit permissions on each of these objects - e.g., under Settings for a project, you'll find a button or something to edit the permissions for that project. 

Users will see permissions presented as a table - the X axis is groups of users, the Y axis is the things that can be granted for that object type. 

| Group            | Edit variables       | Edit deployment process | Create releases | Deploy releases      |
|------------------|----------------------|-------------------------|-----------------|----------------------|
| Testers          | Yes (dev, test only) | Yes                     |                 | Yes (dev, test only) |
| Release Managers | Yes                  | Yes                     | Yes             | Yes                  |
| Guests           |                      |                         |                 |                      |

From a code point of view, I imagine these will be strongly typed objects (e.g., a ProjectPermissionSet, EnvironmentPermissionSet). The REST API can then make it easy to assert that a set of permissions is "valid", and can enforce logical invariants (e.g., if you can edit the process, you must be able to view a project). 

You can see that the grants on these permissions can be conditionally scoped. You can scope them by environment, or by tenant - nothing else. 

### Child objects

Permission for objects which belong to one of the objects listed above will have their permissions defined on the parent object.

These are objects which are much more likely to be treated as a class, rather than individual objects.  Examples (including owners) are:

- Tenants (Space)
- Library Variable Sets (Space)
- Accounts (Space)
- Lifecycles (Space)
- Certificates (Space)
- Release (Project)
- Deployment Process (Project)
- Target (Environment)

For example, the permissions for a Space may appear as:

| Group            | Edit Tenants       | Edit Library Variable Sets | Edit Accounts        | Edit Certificates    |
|------------------|--------------------|----------------------------|----------------------|----------------------|
| Testers          | Yes                | Yes                        | Yes (dev, test only) | Yes (dev, test only) |
| Release Managers | Yes                | Yes                        | Yes                  | Yes                  |
| Guests           |                    |                            |                      |                      |



## 5. Owners
We'll introduce the concept of "owners" for these objects. This is the most powerful permission on an object.

| Group            | Edit variables       | Edit deployment process | Create releases | Deploy releases      | Owner   |
|------------------|----------------------|-------------------------|-----------------|----------------------|---------|
| Testers          | Yes (dev, test only) | Yes                     | No              | Yes (dev, test only) |         |
| Release Managers | Yes                  | Yes                     | Yes             | Yes                  |         |
| Project Admins   |                      |                         |                 |                      | Yes     |
| Guests           |                      |                         |                 |                      |         |

The "Owner" permission lets gives you the ability to change permissions on an object. There must be at least one group that has "owner" permissions (even if no one is in that group). The initial owner group\s will be selected when the object is created.

## 6. Simplify
We'll simplify the number of available permissions down to something more sensible, and that better maps to the model. We'll no longer simply have XView, XEdit, XCreate, XDelete permissions. 

For example:

 - A library variable set would have permissions for:
   - Editing variables (scoped to environments/tenant tags)
   - Importing that variable set into a project
 - An environment would have:
   - Editing the machines in the environment
   - Performing Tentacle upgrades
   


## 7. Administrators cannot do everything by default

Currently members of the Administrators group can do everything, and this cannot be restricted.

This is sometimes not desirable.  In large organisations, often the person\s responsible for adminstering the Octopus server do not want to have permissions to, for example, deploy projects. 

In the new model, Administrators will have permissions to the "Octopus Server" object. They will have permissions to create Spaces.  When creating a Space, they will be able to select the Owner group, which may be a group that they are not a member of; at that point they will not have any edit permissions to the Space. 

# Implementation thoughts

I think it might be possible to use this approach as the way we model permissions (teams, etc.) but keep the existing code for how we assert permissions. When you authenticate with Octopus we build a PermissionSet with all the things you can do - I believe that same structure might still apply. 

# Walk-through

Let's see how a few scenarios might play out. 

## New Octopus Server

Alice Administrator creates a new Octopus Server. She is a member of the `Octopus Administrators` group.

**Octopus Server permissions:**

| Group                 |  Owner               |  Administer System         |     Create Space         | 
|--------------------   |----------------------|----------------------------|--------------------------|
| Octopus Administrators| Yes                  | Yes                        | Yes                      |
| Everyone              |                      |                            |                          |


Bob ProjectManager is the project manager for the Acme Online Store project.  He requests a number of new groups be created:

- Acme Managers 
- Acme Testers 
- Acme Developers
- Acme Operations

And a new `Acme` space is created with `Acme Managers` as the owner. Bob then assigns some permissions on the Space:  

**Acme Space permissions:**

| Group            |  Owner  | Create Environments | Create Projects   | Edit Certificates  | Edit Library Variable Sets  | Edit Accounts |
|---------------   |---------|---------------------|-------------------|--------------------|-----------------------------|---------------|
| Acme Managers    | Yes     |   Yes               | Yes               |  Yes               | Yes                         | Yes           |
| Acme Testers     |         |                     |                   |                    |                             |               |
| Acme Developers  |         |                     | Yes               |                    | Yes                         |               |
| Acme Operations  |         |  Yes                |                   |  Yes               |                             | Yes           |

Charlie Operations (a member of `Acme Operations`) then creates the Environments: `Dev`, `Test`, `Prod`.

`Acme Developers` are granted some permissions for the lower environments:

**Acme Space permissions:**

| Group            |  Owner  | Create Environments | Create Projects   | Edit Certificates  | Edit Library Variable Sets  | Edit Accounts       |
|---------------   |---------|---------------------|-------------------|--------------------|-----------------------------|---------------------|
| Acme Managers    | Yes     |   Yes               | Yes               |  Yes               | Yes                         | Yes                 |
| Acme Testers     |         |                     |                   |                    |                             |                     |
| Acme Developers  |         |                     | Yes               |  Yes (dev and test)| Yes                         | Yes (dev and test)  |
| Acme Operations  |         |  Yes                |                   |  Yes               |                             | Yes                 |


Bob ProjectManager creates a new Project: `Acme Online` with `Acme Managers` as the owner.  He grants some Project level permissions:

**Acme Online Project permissions:**

| Group            |  Owner  | Edit Deployment Process | Edit Variables | Manage Releases | Deploy Releases | Manage Triggers |
|---------------   |---------|-------------------------|----------------|-----------------|-----------------|-----------------|
| Acme Managers    | Yes     | Yes                     | Yes            | Yes             | Yes             | Yes             |
| Acme Testers     |         |                         |                |                 | Yes (test)      |                 |
| Acme Developers  |         | Yes                     | Yes (dev,test) | Yes             | Yes (dev)       |                 |
| Acme Operations  |         |                         | Yes            |                 |                 | Yes             |

# Permissions List

This will be undoubtedly be incomplete, but will hopefully give a representative set. 

| Name                   | Object           | Supports Restriction     |
|------------------------|------------------|--------------------------|
| Owner                  | Octopus Server   |                          |
| AdministerSystem       | Octopus Server   |                          |
| EditGroup              | Octopus Server   |                          |
| BuiltInFeedPush        | Octopus Server   |                          |
| CreateSpace            | Octopus Server   |                          |
| TaskView               | Octopus Server   |                          |
| TaskEdit               | Octopus Server   |                          |
| Owner                  | Space            |                          |
| ViewSpace              | Space            |                          |
| EnvironmentCreate      | Space            |                          |
| ProjectCreate          | Space            |                          |
| LibraryVariableSetEdit | Space            |                          |
| ProjectGroupEdit       | Space            |                          |
| TaskEdit               | Space            |                          |
| StepTemplateEdit       | Space            |                          |
| LifecycleEdit          | Space            |                          |
| TenantEdit             | Space            |                          |
| TagSetEdit             | Space            |                          |
| MachinePolicyEdit      | Space            |                          |
| ProxyEdit              | Space            |                          |
| SubscriptionEdit       | Space            |                          |
| TriggerEdit            | Space            |                          |
| CertificateEdit        | Space            | Environment, Tenant      |
| CertificateExportPK    | Space            | Environment, Tenant      |
| Owner                  | Project          |                          |
| ProjectEdit            | Project          |                          |
| ProcessEdit            | Project          |                          |
| VariableEdit           | Project          | Environment, Tenant      |
| Release                | Project          |                          |
| DefectReport           | Project          |                          |
| DefectResolve          | Project          |                          |
| Deploy                 | Project          | Environment, Tenant      |
| ArtifactEdit           | Project          | Environment, Tenant      |
| InterruptionEdit       | Project          | Environment, Tenant      |
| Owner                  | Environment      |                          |
| EnvironmentEdit        | Environment      |                          |
| MachineEdit            | Environment      | Tenant                   |

# Migration

_deep breath_ 