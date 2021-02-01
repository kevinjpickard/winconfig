Configuration gaming
{
  param
  (
    [string[]]$ComputerName = 'localhost'
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DscResource -Name PackageManagement,PackageManagementSource
  Import-DscResource -ModuleName cChoco
  Import-DscResource -ModuleName ComputerManagementDsc

  Node $ComputerName
  {
    LocalConfigurationManager {
      DebugMode = 'ForceModuleImport'
    }

    PackageManagement Chocolatier {
      Name = 'Chocolatier'
      Source = 'PSGallery'
    }

    PackageManagement WinGet {
      Name = 'WinGet'
      Source = 'PSGallery'
    }

    PackageManagement SysInternals {
      Name = 'sysinternals'
      RequiredVersion = 'latest'
      ProviderName = 'chocolatier'
      DependsOn = '[PackageManagement]Chocolatier'
    }

    $chocoPackages = @(
        "battle.net",
        "epicgameslauncher",
        "goggalaxy",
        "origin",
        "steam",
        "uplay"
    )

    foreach ($package in $chocoPackages) {
      PackageManagement "Install_$package" {
        Name = $package
        RequiredVersion = 'latest'
        ProviderName = 'chocolatier'
        DependsOn = '[PackageManagement]Chocolatier'
      }
    }

    $winGetPackages = @(
      "Discord.Discord",
      "nvidia.GeforceExperience"
    )

    foreach ($package in $winGetPackages) {
      PackageManagement "Install_$package" {
        Name = $package
        #RequiredVersion = 'latest'
        ProviderName = 'winget'
        DependsOn = '[PackageManagement]WinGet'
      }
    }
  }
}

gaming
