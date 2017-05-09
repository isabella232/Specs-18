# Remote Release Promotions

This is the living specification for the _Remote Release Promotions_ feature.

This feature will allow promoting a Release between Spaces.

## Concepts

- Release Bundle: The promotion artifact. This will contain everything required to transport the release from one Octopus Space to another.   
- Deployment Receipt: A document representing the result of a deployment. This will be used to display the results of a remote deployment in the source Space. 

## Implementation

### Variables

### Viewing the Deployment Process for a Release

In Octopus today, when you view a project's deployment process you are viewing the latest version.  There is no way to view the process that was snapshotted with a particular release.  

This has always been a gap.  Remote Promotions simply highlights it. 
For example, imagine a project has two Remote Environments: _Staging_ and _Production_.  And two releases have been promoted, a patch release (say `1.0.1`) into _Production_, and a feature release (`2.0`) into _Staging_.
If you were to view the deployment process for the project in the Remote Space, would it show the process as it was at `1.0.1` or `2.0`? 

We are proposing to implement viewing (read-only) the deployment process as it was at the time of the release. This will be useful even in non-remote-promotion scenarios, but will be critical for remote promotions. 