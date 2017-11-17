# Spaces

## The Problem

Octopus was original designed with small teams in mind. Everything is at the global level: Projects, Environments, Lifecycles, Variable-Sets, etc.

In large organizations, as more teams onboard, this doesn't scale well.


## Spaces to the Rescue 

We will push almost everything down a level, into Spaces. Spaces serve to segregate an Octopus Server.      

The only things that will remain global are:

- Octopus Server Configuration (License, Maintenance Mode, HTTPS Certificate, etc)
- Infrastructure: Machines (not Environments) would be added globally 

This means that Spaces will contain:

- Projects
- Environments
- Lifecycles 
- Variable Sets
- Tenants
- Step Templates


### But surely _X_ has to be global

It is easy to imagine scenarios for almost all entities in which one may want them to be global. Not only does this quickly lead to the current situation, it would actually be worse because everything could live at multiple levels.

Our initial position is that everything lives within a space.  If we (or our customers) can produce a very compelling reason why something should be global, we'll reconsider.

## Migration

Everything existing would be moved into a default space.

Ideally, all API endpoints would work as they do today, against the default space.

For example, `/api/projects/all` would retrieve all projects in the default space (which would be everything initially).

## HTTP API

Space would become a component in our HTTP API paths for list operations. e.g.

`/api/{space}/projects/all`

Referencing individual entities would not require a space, as the ID would be unique. e.g. 

`/api/environment/{environment-id}`

## UI

There will be a Space-Switcher in the header:

![ODCM Space Switching](odcm-space-switching-menu.png "width=500")

## Permissions 

???