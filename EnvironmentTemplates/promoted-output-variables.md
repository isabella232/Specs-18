Currently a deployment process can set [output variables](https://octopus.com/docs/deployment-process/variables/output-variables), using something similar to:

```
Set-OctopusVariable -Name "ArmCount" -Value "8"
```

These are then available to subsequent steps in the same process.

This spec proposes allowing an explicit scope to be provided, which would allow the variable to be used outside of the process which sets it's value.

The available scopes would be:

- Environment
- Project
- Target (alias Machine)
- Tenant
- Deployment

Any output variables scoped to environment, tenant, or target will be captured and made available to any subsequent deployments to the environment\tenant\target.

Project-scoped variables will captured against the project and snapshotted with any subsequent releases created of the project. 

To access output variables scoped to a deployment, we will create a new variable type: `Deployment` which will be able to be added to a variable set.  

## Examples

### Capturing an Environment Variable during Provisioning

While executing the provisioning process for a [templated-environment](index.md), we want to capture a value generated as part of the provisioning. 

We do so as:

```
Set-OctopusVariable -Name "FooKey" -Value $fooKey -Environment 
```

Any deployments of any project (or maintenance task) to this environment would then be able to access the variable using:

```
#{FooKey}
```

or

```
$OctopusParameters["FooKey"]
```

### Capturing a Project Variable during a deployment

While executing a deployment process, we can capture a value and promote it to a project variable using:

```
Set-OctopusVariable -Name "InstallLocation" -Value "#{Octopus.Action.Package.InstallationDirectoryPath}" -Project
```

This will then be available and visible as a project variable.