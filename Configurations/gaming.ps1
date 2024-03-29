Configuration gaming
{
  param
  (
    [string[]]$ComputerName = 'localhost'
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DscResource -Name PackageManagement,PackageManagementSource
  Import-DscResource -ModuleName ComputerManagementDsc

  Node $ComputerName
  {
    LocalConfigurationManager {
      DebugMode = 'ForceModuleImport'
    }

    PackageManagement ChocolateyGet {
      Name = 'ChocolateyGet'
      Source = 'PSGallery'
    }

    PackageManagement WinGet {
      Name = 'WinGet'
      Source = 'PSGallery'
    }

    PackageManagement SysInternals {
      Name = 'sysinternals'
      RequiredVersion = 'latest'
      ProviderName = 'ChocolateyGet'
      DependsOn = '[PackageManagement]ChocolateyGet'
    }

    $chocoPackages = @(
        "battle.net",
        "epicgameslauncher",
        "goggalaxy",
        "origin",
        "steam",
        "uplay",
        "discord",
        "geforce-experience"
    )

    foreach ($package in $chocoPackages) {
      PackageManagement "Install_$package" {
        Name = $package
        RequiredVersion = 'latest'
        ProviderName = 'ChocolateyGet'
        DependsOn = '[PackageManagement]ChocolateyGet'
      }
    }

    # $winGetPackages = @(
    #   "Discord.Discord",
    #   "nvidia.GeforceExperience"
    # )

    # foreach ($package in $winGetPackages) {
    #   PackageManagement "Install_$package" {
    #     Name = $package
    #     #RequiredVersion = 'latest'
    #     ProviderName = 'winget'
    #     DependsOn = '[PackageManagement]WinGet'
    #   }
    # }
  }
}

gaming
