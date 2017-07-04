## JAR and WAR packages

The Octopus built-in feed will be extended to support JAR and WAR files.

### Versioning

It seems the most appropriate place to get the version information from is the [Implementation-Version field of the JAR file's manifest](http://docs.oracle.com/javase/tutorial/deployment/jar/packageman.html).  

For consistency with other package-types, we could also allow the version to be supplied in the file-name ([though this won't work with WAR files](http://fredpuls.com/site/softwaredevelopment/java/deploy/deploy_war_file_versioning_and.htm)). 

So we would attempt to retrieve the version from (in order of priority):

1. `Implementation-Version` field of the manifest
1. Package file-name (e.g. `MyJavaProject.1.0.0.jar`)