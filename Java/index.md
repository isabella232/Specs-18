## Java Support in Octopus Deploy

This is the live specification for first-class Java support in Octopus Deploy.

### Phase 1 (Release 3.16) -- Done

#### Remove the Mono dependency for SSH targets 

Build a .NET Core Self-Contained Calamari which will not require Mono to be pre-installed on SSH targets.

Many Java teams target Linux as the server OS, and for some installing Mono was a blocker to using Octopus.   

### Phase II (Release 3.17, September)

#### JAR Packages

We will extend the Octopus built-in package repository to support JAR, WAR, and EAR files. 

**Note:** JAR packages will need to be named in the `{{PackageId}}.{{Version}}.{{Extension}}` format, similar to zips.   
We originally considered allowing package ID and version information to be stored in the manifest of the JAR, but we didn't feel that extracting the JAR using [SharpCompress](https://github.com/adamhathcock/sharpcompress) was a robust solution. We feel the most robust solution is to use the Java tooling (i.e. [jar tool](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/jar.html), this is what we do on the target) but this would require having the JRE installed on the Octopus Server.   
We may investigate this further in the future. 

#### New Step Types

We are adding the following built-in steps (names may change):

- **Deploy Java Archive**
- **Deploy to Tomcat**
- **Start/Stop Tomcat App** 
- **Deploy to WildFly or RedHat JBoss EAP**
- **Enable/Disable Deployment in WildFly**

The 3 new deploy steps (`Deploy Java Archive`, `Deploy to Tomcat`, `Deploy to WildFly`) will all extract and re-package the Java Archive.  This allows features such  as `Substitute Variables in Files` and `JSON Configuration` to be run.

Pre/Deploy/Post scripts will be executed, similar to the _Deploy Package_ step.

**Note:** The Java Runtime (JRE) will need to be installed on the Tentacle that runs the steps above.   
At some point in the future, we will likely allowing pushing this automatically. This will require platform detection.

[Notes on the decision to add new Deploy Java Archive step rather than modify Deploy Package to work with JAR files.](deploy-java-archive-vs-deploy-package.md)

### Phase III (Octopus 3.18, October)

Yet to be finalized, but possibly:

- Support for Maven Package Feeds
- `systemd` built-in step
- Python scripts

