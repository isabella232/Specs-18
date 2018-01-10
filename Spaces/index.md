# Spaces

## The Problem

Octopus was original designed with small teams in mind. Everything is at the global level: Projects, Environments, Lifecycles, Variable-Sets, etc.

In large organizations, as more teams onboard, this doesn't scale well:

- People end up "namespacing" things to avoid conflicts and confusion: "This is our `Production` environment"
- People struggle to provide any segregation using our permission system. We introduced the ability to "scope" a Team to a certain Environment or Project, and later had to introduce Tenants and Project Groups into the mix.

## Spaces to the Rescue 

We will push almost everything down a level, into Spaces. Spaces serve to segregate an Octopus Server.      

The only things that will remain global are:

- Octopus Server Configuration (License, Maintenance Mode, HTTPS Certificate, etc)
- Users
- Teams and Roles (see below)
- Built-in Package Repository

This means that Spaces will contain:

- Projects
- Environments
- Lifecycles 
- Accounts
- Certificates
- Variable Sets
- Tenants (Tenant feature-toggle will be pushed down into Spaces)
- Step Templates

### Teams and Roles

Teams will remain global, but will be modified slightly from today. 

Roles will exist at both the Server and Space levels, as appropriate.

### But surely _X_ has to be global

It is easy to imagine scenarios for almost all entities in which one may want them to be global. Not only does this quickly lead to the current situation, it would actually be worse because everything could live at multiple levels.

Our initial position is that everything above lives within a space.  If we (or our customers) can produce a very compelling reason why something should be global, we'll reconsider.

## Tasks 

Can be viewed at the server level or within a Space. The Space-view just provides a filtered-view.

## Audit Log

Similar to Tasks, audit logs can be viewed globally or within a Space.  The Space provides a filtered view.

## Migration

Everything existing would be moved into a default space.

Ideally, all API endpoints would work as they do today, against the default space.

For example, `/api/projects/all` would retrieve all projects in the default space (which would be everything initially).

After this, people would start making other spaces and moving things into those other spaces. We will provide some tooling to take a Project and all the things it needs into another space.

## HTTP API

Space would become a component in our HTTP API paths for list operations. e.g.

`/api/{space}/projects/all`

For backwards compatibility we would infer the default space if one isn't specified in the path. e.g.

`/api/projects/all` would retrieve all projects in the default space.


Referencing individual entities should still require a space (unless it's the default space) since some resources (like projects) can be reference by name, which _may only be unique within a space?_

## UI

There will be a Space-Switcher in the header:

![ODCM Space Switching](odcm-space-switching-menu.png "width=500")

## Permissions 

Some changes to the Permissions model are required to support Spaces. 
[Two options](../Permissions/index.md) were considered. [Plan B](../permissions/Permissions-PlanB.md) was decided on. 

## Targets

We considered allowing Targets to live at the Server level, and having them included in Environments within a Space. 

We decided that targets would be added to and belong to a Space. If the same physical target is used in multiple Spaces, then it will be represented by multiple targets in Octopus. 
