## Java Support in Octopus Deploy

This is the live specification for first-class Java support in Octopus Deploy.

### Package Types

We plan to [add support for JAR and WAR package types](jar-packages.md).

### Step Types

We are planning to add a new _Deploy Java Archive_ step type.

The alternative was to modify the existing _Deploy a Package_ step to work with Java packages.  

The benefits of adding a new step type:

- Discoverability: It is immediately obvious that it will work with Java packages. 
- We are free to add conventions and features relevant to Java archives without concern as to how the will impact existing packages.
- It fits with our direction of more specific steps, rather than fewer generic steps.

The _Deploy Java Archive_ step will extract the archive, allowing conventions such as variable-substitution to be performed. It will then re-pack the archive and move it to it's destination.

Pre/Deploy/Post scripts will be executed, similar to the _Deploy Package_ step.

We intend to add more steps, to support deploying to the common Java Application Servers (e.g. Tomcat, WildFly, etc). These can be based the _Deploy Java Archive_ step, possibly simply enabling specific features, similar to how the _Deploy IIS WebSite_ and _Deploy Windows Service_ steps are based on the _Deploy Package_ step. 