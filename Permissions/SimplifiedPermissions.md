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

First, we assume that nobody has permission to do anything (like now) unless granted that permission explicitly. 

Second, we'll introduce "groups", which are collections of users or map to external security groups (AD groups). "Octopus Administrators" and "Everyone" become built in groups. Unlike "teams", a group is just a collection of people - it defines nothing about what those people can do. 

Third, insetad of a global set of teams, we allow certain classes of objects to have permissions granted directly on them. It's similiar to how Windows allows you to set permissions on individual files/directories rather than some big global permission system. 

 - Octopus server as a whole
 - Project group
 - Project
 - Environment
 - Library variable set
 - Tenants
 
In the UI, this will appear as a button to edit permissions on each of these objects - e.g., under Settings for a project, you'll find a button or something to edit the permissions for that project. 

Users will see permissions presented as a table - the X axis is groups of users, the Y axis is the things that can be granted for that object type. 

| Group            | View Project | Edit variables       | Edit deployment process | Create releases | Deploy releases      |
|------------------|--------------|----------------------|-------------------------|-----------------|----------------------|
| Testers          | Yes          | Yes (dev, test only) | Yes                     |                 | Yes (dev, test only) |
| Release Managers | Yes          | Yes                  | Yes                     | Yes             | Yes                  |
| Guests           | Yes          |                      |                         |                 |                      |

From a code point of view, I imagine these will be strongly typed objects (e.g., a ProjectPermissionSet, EnvironmentPermissionSet). The REST API can then make it easy to assert that a set of permissions is "valid", and can enforce logical invariants (e.g., if you can edit the process, you must be able to view a project). 

You can see that the grants on these permissions can be conditionally scoped. You can scope them by environment, or by tenant - nothing else. 

Fourth, we'll simplify the number of available permissions down to something more sensible, and that better maps to the model. We'll no longer simply have XView, XEdit, XCreate permissions. 

For starters, we'll eliminate the number of "view" permissions. If you can view a project, you can automatically view everything about that project - the process, the variables and their values (of course not sensitive ones), the releases, and the deployments. There will no longer be individual view permissions.  

For example:

 - A library variable set would have permissions for:
   - Viewing the variable set (you can view all values)
   - Editing variables (scoped to environments/tenant tags)
   - Importing that variable set into a project
 - An environment would have:
   - Editing the machines in the environment
   - Performing Tentacle upgrades
   
Environments would no longer have View permissions either - you'd see environments based on what projects you can see (I think - need to think about that some more). 

Fifth, we'll introduce the concept of "owners" for these objects. This is the most powerful permission on an object.

| Group            | View Project | Edit variables       | Edit deployment process | Create releases | Deploy releases      | Owner   |
|------------------|--------------|----------------------|-------------------------|-----------------|----------------------|---------|
| Testers          | Yes          | Yes (dev, test only) | Yes                     | No              | Yes (dev, test only) |         |
| Release Managers | Yes          | Yes                  | Yes                     | Yes             | Yes                  |         |
| Project Admins   |              |                      |                         |                 |                      | Yes     |
| Guests           | Yes          |                      |                         |                 |                      |         |

The "Owner" permission lets gives you the ability to change permissions on an object. There must be at least one group that has "owner" permissions (even if no one is in that group), and by default it will be the Octopus Administrators groups. 

# Implementation thoughts

I think it might be possible to use this approach as the way we model permisisons (teams, etc.) but keep the existing code for how we assert permissions. When you authenticate with Octopus we build a PermissionSet with all the things you can do - I believe that same structure might still apply. 
