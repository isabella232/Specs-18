In the [previous document](SimplifiedPermissions.md) we designed an ideal permissions model if we were starting over today.  But we're not starting over, and unfortunately we couldn't produce a palatable migration strategy from the current permission model to our proposed model.

The greatest benefit (from a development perspective) of the previous proposed model was also the greatest difficultly for migration: _Being able to view everything in a Space_.  The idea that a user could go from being able to see two projects one day, to suddenly being able to see hundreds was a deal-breaker. 

# Plan B 

## 1. Groups
We'll introduce "groups", which are collections of users or map to external security groups (AD groups). "Octopus Administrators" and "Everyone" become built in groups. Unlike "teams", a group is just a collection of people - it defines nothing about what those people can do. Groups will replace Teams, and will live at the Server level.

## 2. Most Roles Assigned within Spaces 

**Roles will exist at both the Server and Space levels**.

Whereas today all Roles are at the Server level, in this model most Roles will be assigned to Groups at the Space level.  

The only Roles that will remain at the Server level are those related to administering the Octopus Server, manage Spaces, and publish packages to the built-in feed. 

All Roles relating to Projects, Environments, Tenants, etc, will be pushed down into the Spaces. e.g.

- Project XXX
- Environment XXX
- Tenant Manager

The big difference is that Roles are assigned to Groups, and scoped if required.
The same Role may be assigned multiple Scopes. 

For example, the `Acme Developers` group may be assigned the following Roles within a Space:

| Role                | Scope                             | 
|---------------------|-----------------------------------|
| Project Contributor |                                   | 
| Project Deployer    | Project:Acme; Environment:Dev     |
| Environment Manager | Environment:Dev                   |

## 3. Space Owners 
Spaces will have owners.  The owners of a Space can assign permissions for the Space.  Octopus Administrators will be able to delegate the management of a Space.   

Octopus Administrators do not have permissions within a Space by default.

# Migration

Migration to this model is fairly trivial.  If this is implemented at the same time as [Spaces](../Spaces/index.md), then everything will be initially placed in a default Space, and all existing Roles will be allocated in this Space.  

Teams will be directly translated into Groups.

Existing Octopus Administrators will have the ability to Create\Modify\Delete Spaces.