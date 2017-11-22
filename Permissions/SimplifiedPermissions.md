We want to simplify permissions in Octopus. Goals:

 - For customers, it should be easy to reason about what permissions someone has when using Octopus
 - It should be possible to delegate some level of ownership for permissions
 
Right now Octopus uses the following:

 - Permission - an enum of things that can be done ("ProjectView", "DeploymentCreate")
 - Role - a group of common permissions ("Project viewer: has ProjectView, EnvironmentView")
 - Team - assign a role to people, and scopes it to a project/environment

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
- Library variable set
- Tenants
 
In the UI, this will appear as a button to edit permissions on each of these objects - e.g., under Settings for a project, you'll find a button or something to edit the permissions for that project. 

Users will see permissions presented as a table - the X axis is groups of users, the Y axis is the things that can be granted for that object type. 

| Group            | Edit variables       | Edit deployment process | Create releases | Deploy releases      |
|------------------|----------------------|-------------------------|-----------------|----------------------|
| Testers          | Yes (dev, test only) | Yes                     |                 | Yes (dev, test only) |
| Release Managers | Yes                  | Yes                     | Yes             | Yes                  |
| Guests           |                      |                         |                 |                      |

From a code point of view, I imagine these will be strongly typed objects (e.g., a ProjectPermissionSet, EnvironmentPermissionSet). The REST API can then make it easy to assert that a set of permissions is "valid", and can enforce logical invariants (e.g., if you can edit the process, you must be able to view a project). 

You can see that the grants on these permissions can be conditionally scoped. You can scope them by environment, or by tenant - nothing else. 

## 5. Simplify
We'll simplify the number of available permissions down to something more sensible, and that better maps to the model. We'll no longer simply have XView, XEdit, XCreate, XDelete permissions. 

For example:

 - A library variable set would have permissions for:
   - Editing variables (scoped to environments/tenant tags)
   - Importing that variable set into a project
 - An environment would have:
   - Editing the machines in the environment
   - Performing Tentacle upgrades
   

## 6. Owners
We'll introduce the concept of "owners" for these objects. This is the most powerful permission on an object.

| Group            | Edit variables       | Edit deployment process | Create releases | Deploy releases      | Owner   |
|------------------|----------------------|-------------------------|-----------------|----------------------|---------|
| Testers          | Yes (dev, test only) | Yes                     | No              | Yes (dev, test only) |         |
| Release Managers | Yes                  | Yes                     | Yes             | Yes                  |         |
| Project Admins   |                      |                         |                 |                      | Yes     |
| Guests           |                      |                         |                 |                      |         |

The "Owner" permission lets gives you the ability to change permissions on an object. There must be at least one group that has "owner" permissions (even if no one is in that group). The initial owner group\s will be selected when the object is created.

## 7. Administrators cannot do everything by default

Currently members of the Administrators group can do everything, and this cannot be restricted.

This is sometimes not desirable.  In large organisations, often the person\s responsible for adminstering the Octopus server do not want to have permissions to, for example, deploy projects. 

In the new model, Administrators will have permissions to the "Octopus Server" object. They will have permissions to create Spaces.  When creating a Space, they will be able to select the Owner group, which may be a group that they are not a member of; at that point they will not have any edit permissions to the Space. 

# Implementation thoughts

I think it might be possible to use this approach as the way we model permissions (teams, etc.) but keep the existing code for how we assert permissions. When you authenticate with Octopus we build a PermissionSet with all the things you can do - I believe that same structure might still apply. 
