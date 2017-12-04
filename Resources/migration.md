# [Resources](index.md) #
## Migration ##
Pretty much _all_ steps already describe a resource, it's just that we have never exposed/extracted that concept to the user. Since a resource is just an emergent concept from any deployment process, we _should_ be able to determine the base resource type that existing deployment steps could be referring to. This could be just an `IDeployable`-type resource to begin with. Azure deployment steps typically use very specific steps, which we can determine the appropriate Azure-type resource that they should map to. 

Determining the rules that make up a resource, while a little more involved, _should_ be possible given the information already available, with a few caveats. 

- Target Roles becomes resource rules. 
- Tentacles (on-prem infrastructure) no longer is assigned to environments and instead an environment tag is created, assigned to the target and added to the resource as a rule. Alternatively rather than tags the Targets could be just explicitly added to the rules (under the relevant environments).
- Converting existing permission structures to the new one may be more involved. Potentially we will need to to introspection on teams/permissions that exist, determine the appropriate "[Octopus subscription](../permissions.md)" that applied accordingly.

These may not be the ideal configurations if a user was starting an Octopus installation from scratch, but it should allow their deployments to continue immediately when upgrading.