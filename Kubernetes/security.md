## Container Security

### For Octopus Containers
We currently use `microsoft/windowsservercore:latest` for Octopus Server & Tentacle (soon to include 1806). This is not the reccomended approach
Server should be updated to something like `microsoft/windowsservercore:1709` and `microsoft/windowsservercore:1803`

And `microsoft/dotnet:2.1-runtime-alpine` & `microsoft/dotnet:2.1-runtime-nanoserver-sac2016` for OctopusClients


We should be watching for changes to these images, either through a push mechanism, or polling and comparing hashes with a pull.

[Read More](https://blogs.msdn.microsoft.com/dotnet/2018/06/18/staying-up-to-date-with-net-container-images/)
Aqua seems to be the hottness after talking to some people at Dockercon

### For Users containers
We probably want to provide some sort of security scanning process in deployment. Perhaps as a step or pipeline event?
