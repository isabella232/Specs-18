process {
  step {
    actions {
      ActionType = "Octopus.Script"
      CanBeUsedForProjectVersioning = false
      Channels = []
      Environments = []
      ExcludedEnvironments = []
      Id = "3634077a-628d-4f0e-80d8-42099b3f1313"
      IsDisabled = false
      IsRequired = false
      Links = {}
      Name = "Simple Script Step"
      Packages = []
      Properties = {
        "Octopus.Action.RunOnServer" = "false"
        "Octopus.Action.Script.ScriptBody" = "Write-Host \"hi\""
        "Octopus.Action.Script.ScriptSource" = "Inline"
        "Octopus.Action.Script.Syntax" = "PowerShell"
      }
      TenantTags = []
      WorkerPoolId = 
    }
    Condition = "Success"
    Id = "86807484-bf59-4051-90f4-b1773d89280e"
    Name = "Simple Script Step"
    PackageRequirement = "LetOctopusDecide"
    Properties = {
      "Octopus.Action.TargetRoles" = "web-server"
    }
    StartTrigger = "StartAfterPrevious"
  }
  steps{
    actions {
      ActionType = "Octopus.IIS"
      CanBeUsedForProjectVersioning = true
      Channels = []
      Environments = []
      ExcludedEnvironments = []
      Id = "5736efc0-02ef-46e7-87d9-ecdf7be56900"
      IsDisabled = false
      IsRequired = false
      Links = {}
      Name = "Deploy to IIS"
      Packages = {
        AcquisitionLocation = "Server"
        FeedId = "Feeds-1261"
        Id = "e26db06f-9f76-4020-a1ca-e2c8461bcb67"
        Name = ""
        PackageId = "MyWebsite"
      }
      properties {
        "Octopus.Action.CustomScripts.PostDeploy.ps1" = "Write-Host \"Hi\"\n\nif($a -eq 1) {\n \tWrite-Verbose \"Boom\"\n}"
        "Octopus.Action.CustomScripts.PreDeploy.ps1" = "Write-Host \"Hi\"\n\nif($a -eq 1) {\n \tWrite-Verbose \"Boom\"\n}"
        "Octopus.Action.EnabledFeatures" = "Octopus.Features.IISWebSite,Octopus.Features.CustomDirectory,Octopus.Features.CustomScripts,Octopus.Features.ConfigurationVariables,Octopus.Features.ConfigurationTransforms"
        "Octopus.Action.IISWebSite.ApplicationPoolFrameworkVersion" = "v4.0"
        "Octopus.Action.IISWebSite.ApplicationPoolIdentityType" = "ApplicationPoolIdentity"
        "Octopus.Action.IISWebSite.ApplicationPoolName" = "#{PoolName}"
        "Octopus.Action.IISWebSite.Bindings" = "[{\"protocol\":\"http\",\"port\":\"80\",\"host\":\"\",\"thumbprint\":null,\"certificateVariable\":null,\"requireSni\":\"False\",\"enabled\":\"True\"},{\"protocol\":\"https\",\"ipAddress\":\"*\",\"port\":\"443\",\"host\":\"TheHost\",\"thumbprint\":\"43257843890257430543\",\"certificateVariable\":null,\"requireSni\":\"True\",\"enabled\":\"True\"}]"
        "Octopus.Action.IISWebSite.CreateOrUpdateWebSite" = "True"
        "Octopus.Action.IISWebSite.DeploymentType" = "webSite"
        "Octopus.Action.IISWebSite.EnableAnonymousAuthentication" = "False"
        "Octopus.Action.IISWebSite.EnableBasicAuthentication" = "True"
        "Octopus.Action.IISWebSite.EnableWindowsAuthentication" = "True"
        "Octopus.Action.IISWebSite.ExistingBindings" = "Merge"
        "Octopus.Action.IISWebSite.StartApplicationPool" = "True"
        "Octopus.Action.IISWebSite.StartWebSite" = "True"
        "Octopus.Action.IISWebSite.VirtualDirectory.CreateOrUpdate" = "False"
        "Octopus.Action.IISWebSite.WebApplication.ApplicationPoolFrameworkVersion" = "v4.0"
        "Octopus.Action.IISWebSite.WebApplication.ApplicationPoolIdentityType" = "ApplicationPoolIdentity"
        "Octopus.Action.IISWebSite.WebApplication.CreateOrUpdate" = "False"
        "Octopus.Action.IISWebSite.WebRootType" = "packageRoot"
        "Octopus.Action.IISWebSite.WebSiteName" = "MySite"
        "Octopus.Action.Package.AdditionalXmlConfigurationTransforms" = "*.Foo.config =\u003e *.config\ncrossdomainpolicy.#{Octopus.Environment.Name}.xml =\u003e crossdomainpolicy.xml"
        "Octopus.Action.Package.AutomaticallyRunConfigurationTransformationFiles" = "True"
        "Octopus.Action.Package.AutomaticallyUpdateAppSettingsAndConnectionStrings" = "True"
        "Octopus.Action.Package.CustomInstallationDirectory" = "c:\\temp\\#{Octopus.Deployment.Id}"
        "Octopus.Action.Package.CustomInstallationDirectoryPurgeExclusions" = "appsettings.config"
        "Octopus.Action.Package.CustomInstallationDirectoryShouldBePurgedBeforeDeployment" = "True"
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "Octopus.Action.Package.FeedId" = "Feeds-1261"
        "Octopus.Action.Package.PackageId" = "MyWebsite"
      }
      TenantTags = []
      WorkerPoolId = 
    }
    actions {
      ActionType = "Octopus.Script"
      CanBeUsedForProjectVersioning = true
      Channels = []
      Environments = []
      ExcludedEnvironments = []
      Id = "a2039705-1ad0-4f15-ba18-5fc1a1c7de91"
      IsDisabled = false
      IsRequired = false
      Links = {}
      Name = "Script with Additional Package"
      Packages = {
        AcquisitionLocation = "Server"
        FeedId = "Feeds-1261"
        Id = "d3daeb78-3250-45ec-83fe-24ca645c2482"
        Name = ""
        PackageId = "The Package"
        Properties = {}
      }
      Packages = {
        AcquisitionLocation = "Server"
        FeedId = "Feeds-1261"
        Id = "fde83ece-763b-4b1a-8769-792207ecaadf"
        Name = "Other Package"
        PackageId = "Other Package"
        Properties = {
          Extract = "False"
          SelectionMode = "immediate"
        }
      }
      Properties = {
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "Octopus.Action.Package.FeedId" = "Feeds-1261"
        "Octopus.Action.Package.PackageId" = "The Package"
        "Octopus.Action.RunOnServer" = "true"
        "Octopus.Action.Script.ScriptFileName" = "RunMe.ps1"
        "Octopus.Action.Script.ScriptParameters" = "-Path #{MyVar}"
        "Octopus.Action.Script.ScriptSource" = "Package"
      }
      TenantTags = []
      WorkerPoolId = "WorkerPools-261"
    }
    Condition = "Success"
    Id = "e72fcf6e-9e37-4a4d-af9f-ed0ab904a9fe"
    Name = "Deploy to IIS"
    PackageRequirement = "LetOctopusDecide"
    Properties = {
      "Octopus.Action.TargetRoles" = "WebServer"
    }
    StartTrigger = "StartAfterPrevious"
  }
}