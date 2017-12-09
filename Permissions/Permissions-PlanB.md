In the [previous document](SimplifiedPermissions.md) we designed an ideal permissions model if we were starting over today.  But we're not starting over, and unfortunately we couldn't produce a palatable migration strategy from the current permission model to our proposed model.

The greatest benefit (from a development perspective) of the previous proposed model was also the greatest difficultly for migration: _Being able to view everything in a Space_.  The idea that a user could go from being able to see two projects one day, to suddenly being able to see hundreds was a deal-breaker. 

# Plan B 

## 1. Groups
We'll introduce "groups", which are collections of users or map to external security groups (AD groups). "Octopus Administrators" and "Everyone" become built in groups. Unlike "teams", a group is just a collection of people - it defines nothing about what those people can do. Groups will replace Teams.

## 2. Most Permissions Lowered into Spaces
Whereas today all Roles are at the Server level, in this model most permissions will be assigned to Groups at the Space level.  

The only permissions that will remain at the Server level are those related to administering the Octopus Server, and permissions to View\Create\Modify\Delete Spaces. 

For example all permissions relating to Projects, Environments, Tenants, etc, will be pushed down into the Spaces.

## 3. Space Owners 

Spaces will have owners.  The owners of a Space can assign permissions for the Space.  Octopus Administrators will be able to delegate the management of a Space.   

Octopus Administrators do not have permissions within a Space by default.

# Migration

Migration to this model is fairly trivial.  If this is implemented at the same time as [Spaces](../Spaces/index.md), then everything will be initially placed in a default Space, and all existing permissions will be applied to this Space.  

Teams will be directly translated into Groups, and the Groups' permissions will be calculated using the existing Roles.

Existing Octopus Administrators will have the ability to Create\Modify\Delete Spaces.

