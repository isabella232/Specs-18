
_Environments as Cattle, not Pets_

Rather than having a static set of Environments, it is sometimes desirable to have dynamic Environments which created and disposed frequently.  

Example scenarios may be:

- Feature Branches
- Environment-per-tester
- Immutable Infrastructure

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

## Variables

When creating an Environment instance from an Environment Template, variables will be able to be supplied.  These variables will be implicitly scoped to the created environment, but they can also have additional scopes. 

## API

Environment Templates will be a resource with `GET`, `POST`, `PUT`, and `DELETE` actions (just like every other resource) :

```
/api/environmenttemplates
```

There will be a custom endpoint to create an instance of a Template.  e.g.

```
POST /api/environmenttemplates/{{TemplateId}}/instances
```

Retrieving all instances of a Template could possibly be done via the templates endpoint:

```
GET /api/environmenttemplates/{{TemplateId}}/instances
```

or via the environments endpoint:

```
GET /api/environments?template={{TemplateId}}
```

Instances templates can be treated via the API as any other Environment.  For example the response from 

```
GET /api/environments
```

would include any environments created via a template. 



