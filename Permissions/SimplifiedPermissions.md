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

Second, we'll introduce "groups", which are collections of users or map to external security groups (AD groups). 

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
| Testers          | Yes          | Yes (dev, test only) | Yes                     | No              | Yes (dev, test only) |
| Release Managers | Yes          | Yes                  | Yes                     | Yes             | Yes                  |
| Guests           | Yes          |                      |                         |                 |                      |

From a code point of view, I imagine these will be strongly typed objects (e.g., a ProjectPermissionSet, EnvironmentPermissionSet). The REST API can then make it easy to assert that a set of permissions is "valid", and can enforce logical invariants (e.g., if you can edit the process, you must be able to view a project). 

Fourth, we'll introduce the concept of "owners" for these objects. This is the most powerful permission on an object.

| Group            | View Project | Edit variables       | Edit deployment process | Create releases | Deploy releases      | Owner   |
|------------------|--------------|----------------------|-------------------------|-----------------|----------------------|         |
| Testers          | Yes          | Yes (dev, test only) | Yes                     | No              | Yes (dev, test only) |         |
| Release Managers | Yes          | Yes                  | Yes                     | Yes             | Yes                  |         |
| Project Admins   |              |                      |                         |                 |                      | Yes     |
| Guests           | Yes          |                      |                         |                 |                      |         |

The "Owner" permission lets gives you the ability to change permissions on an object. There must be at least one group that has "owner" permissions (even if no one is in that group), 
