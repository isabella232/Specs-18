## JAR and WAR packages

The Octopus built-in feed will be extended to support JAR and WAR files.

### Versioning

It seems the most appropriate place to get the version information from is the [Implementation-Version field of the JAR file's manifest](http://docs.oracle.com/javase/tutorial/deployment/jar/packageman.html).  

For consistency with other package-types, we could also allow the version to be supplied in the file-name ([though this won't work with WAR files](http://fredpuls.com/site/softwaredevelopment/java/deploy/deploy_war_file_versioning_and.htm)). 

So we would attempt to retrieve the version from (in order of priority):

1. `Implementation-Version` field of the manifest
1. Package file-name (e.g. `MyJavaProject.1.0.0.jar`)

### Storing packages on disk 

The built-in package-feed stores the package files on the file-system.

Currently the package files are stored in a single-directory, with the files named as `{PackageId}.{Version}.{Extension}` e.g. `Acme.Web.2.0.0-beta.1.nupkg`

Since JAR (and especially WAR) package files often retain the same name for different versions, we will need to modify this approach. 

We propose taking the approach (similar to modern versions of NuGet) of storing the packages files in directory hierarchy:
`{PackageId}\{Version}\{FileName}` e.g. `Acme.Web\2.0.0-beta.1\Acme.Web.jar` 
(the file-name can still include the version, that is fine).