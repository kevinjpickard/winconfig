Configuration dev
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

    $chocoPackages = @(
        "7zip",
        "awscli",
        "cmake",
        "git",
        "golang",
        "googlechrome",
        "make",
        "microsoft-windows-terminal",
        "neovim",
        "powershell-core",
        "python",
        "sysinternals",
        "vagrant",
        "vscode",
        "vmwareworkstation",
        "keybase",
        "pia"
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
      "Spotify",
      "1password"
    )

    foreach ($package in $winGetPackages) {
      PackageManagement "Install_$package" {
        Name = $package
        #RequiredVersion = 'latest'
        ProviderName = 'winget'
        DependsOn = '[PackageManagement]WinGet'
      }
    }

    UserAccountControl 'ChangeNotificationLevel' {
      IsSingleInstance  = 'Yes'
      NotificationLevel = 'NeverNotifyAndDisableAll'
    }

    PendingReboot RebootIfNeeded {
      Name = 'RebootIfNeeded'
    }
  }
}

dev
