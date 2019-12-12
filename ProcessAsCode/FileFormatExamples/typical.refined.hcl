process {
   inline_script_action "Simple Script Step" {
     run_on_server = false
     target_roles = "web-server"
     syntax = "PowerShell"
     body = <<SCRIPT
      Write-Host "hi"
     SCRIPT
  }

  rolling "Website" {
    target_roles = ["web-server", "dr-web-server"]

    deploy_to_iis "Deploy Website" {

      package {
        feed = "Built-in"
        package_id = "MyWebsite"
      }

      app_pool "${PoolName}" {
        framework = "v4.0"
        identitiy = "ApplicationPoolIdentity"
      }

      web_site "MyWeb" {
        existing_bindings = "Merge"
        basic_authentication = true
        windows_authentication = true

        binding {
          protocol = "HTTP"
          port = 80
          enabled = false
        }

        binding {
          protocol = "HTTPS"
          port = 443
          require_sni = true
          certificate_thumbprint = "ABCDEFG"
          host = "example.com"
        }
      }

      custom_installation_directory {
        path = "c:\temp\#{Octopus.Deployment.Id}"
        purge_before_deployment = true
        purge_exclusions = ["appsettings.config", "logs/**"]
      }

      xml_transformations {
        automatically_run = true
        additional = [
          "*.Foo.config", 
          "*.config\ncrossdomainpolicy.#{Octopus.Environment.Name}.xml", 
          "crossdomainpolicy.xml"
        ]
      }

      custom_scripts {
        pre_deploy = <<SCRIPT
          Write-Host "Hi"

          if($a -eq 1) {
            Write-Verbose "Boom"
            }
        SCRIPT
        post_deploy = <<SCRIPT
          Write-Host "Hi"

          if($a -eq 1) {
            Write-Verbose "Boom"
            }
        SCRIPT
      }
    }

    script_from_package_action "Script with Additional Package" {
      run_on_server = true
      environments = ["Production", "Environments-2"]
      isDisabled = true
      isRequired = true
      download_on_tentacle = true
      file_name = "RunMe.ps1"
      parameters = "-Path #{MyVar}"
      worker_pool = "WorkerPools-261"

      package {
        feed = "Feeds-1261"
        acquisitionLocation = "Server"
        package_id = "The.Package"
      }

      package "Other Package" {
        feed = "Feeds-1261"
        package_id = "Other.Package"
        extract = false,
        selection_mode = "immediate"
      }
    }
  
    # example if we didn't specifically support the step. Same as the first IIS action
    action "Deploy to IIS" { 
      ActionType = "Octopus.IIS"
      package {
        feed = "Built-in"
        package_id = "MyWebsite"
      }
      properties {
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
        "Octopus.Action.Package.AdditionalXmlConfigurationTransforms" =  = <<BLOCK
          *.Foo.config =\u003e *.config\ncrossdomainpolicy.#{Octopus.Environment.Name}.xml
          crossdomainpolicy.xml
        BLOCK
         "Octopus.Action.CustomScripts.PostDeploy.ps1" = <<SCRIPT
          Write-Host "Hi"

          if($a -eq 1) {
            Write-Verbose "Boom"
            }
        SCRIPT
        "Octopus.Action.CustomScripts.PreDeploy.ps1" = <<SCRIPT
          Write-Host "Hi"

          if($a -eq 1) {
            Write-Verbose "Boom"
            }
        SCRIPT
        "Octopus.Action.Package.AutomaticallyRunConfigurationTransformationFiles" = "True"
        "Octopus.Action.Package.AutomaticallyUpdateAppSettingsAndConnectionStrings" = "True"
        "Octopus.Action.Package.CustomInstallationDirectory" = "c:\\temp\\#{Octopus.Deployment.Id}"
        "Octopus.Action.Package.CustomInstallationDirectoryPurgeExclusions" = "appsettings.config"
        "Octopus.Action.Package.CustomInstallationDirectoryShouldBePurgedBeforeDeployment" = "True"
      }
    }
  }
}