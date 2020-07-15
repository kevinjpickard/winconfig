Configuration WindowsDevConfiguration
{
  param
  (
    [string[]]$ComputerName = 'localhost'
  )

  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DscResource -ModuleName cChoco

  Node $ComputerName
  {
    LocalConfigurationManager {
      DebugMode = 'ForceModuleImport'
    }

    cChocoInstaller installChoco {
      InstallDir = "c:\choco"
    }

    cChocoPackageInstaller install_InnoSetup {
      Name    = "InnoSetup"
      Ensure  = 'Present'
      Version = "5.6.1"
      DependsOn = "[cChocoInstaller]installChoco"
    }

    cChocoPackageInstallerSet installOtherDevDependencies {
      Ensure    = 'Present'
      Name      = @(
        "7zip",
        "awscli",
        "cmake",
        "git",
        "golang",
        "make",
        "python",
        "sysinternals"
      )
      DependsOn = "[cChocoInstaller]installChoco"
    }

    cChocoPackageInstaller install_Visual_Studio {
      Name = "VisualStudio2019Professional"
      Ensure = 'Present'
      Params = '--includeRecommended --passive --locale en-US'
      DependsOn = "[cChocoInstaller]installChoco"
    }

    Environment addCMakeToPath {
      Name   = 'CMakePathVariable'
      Value  = "C:\Program Files\CMake\bin"
      Path   = $True
      Ensure = 'Present'
      DependsOn = "[cChocoPackageInstallerSet]installOtherDevDependencies"
    }

    Environment addMinGWToPath {
      Name   = 'MinGWPathVariable'
      Value  = "C:\Program Files\Git\mingw64\bin"
      Path   = $True
      Ensure = 'Present'
      DependsOn = "[cChocoPackageInstallerSet]installOtherDevDependencies"
    }

    Environment addGitToPath {
      Name   = 'GitPathVariable'
      Value  = "C:\Program Files\Git\usr\bin"
      Path   = $True
      Ensure = 'Present'
      DependsOn = "[cChocoPackageInstallerSet]installOtherDevDependencies"
    }
  }
}

WindowsDevConfiguration
