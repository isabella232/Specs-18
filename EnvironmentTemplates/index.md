
_Environments as Cattle, not Pets_

Rather than having a static set of Environments, it is sometimes desirable to have dynamic Environments which created and disposed frequently.  An example of this would be creating test environments for feature branches. 

# Environment Templates

We will allow creation of Environment Templates.

## Provisioning Processes 

An Environment Template will allow optional provisioning and de-provisioning processes.

## Triggers

Automatic triggers for deletion of instances of Environment Templates can be configured.

- _X_ days after creation
- If not deployed to for _X_ days
- Release for Project _P_ was deployed to the environment and has been deployed a subsequent phase of the lifecycle. 

## Lifecycles 

Environment Templates can appear in Lifecycles Phases.  

### Required to Progress

When adding an Environment Template to a Lifecycle Phase, you can select whether for the purposes of progression instances of the template: 

- Count as one environment once _any_ instance of the Template has been deployed
- Count as one environment for _each_ deployed instance of the Template 

# Scenarios

- Feature Branches
- Environment-per-tester
- Immutable Infrastructure


