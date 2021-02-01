<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [ValidateSet("gaming", "dev")]
    [String[]]
    $Profiles=@('gaming', 'dev')
)

# Elevate If Needed
$SecurityPrinciple = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
If (-NOT ($SecurityPrinciple.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
  Start-Process powershell -Verb runAs
  Break
}

# Enable and configure WinRM
Set-WSManQuickConfig -Force
winrm set winrm/config '@{MaxEnvelopeSizekb="2563000"}'

# Symlink config files
git submodule update --init --recursive
New-Item -ItemType SymbolicLink -Path $profile -Value $(Resolve-Path ./Microsoft.PowerShell_profile.ps1) -Force
New-Item -ItemType SymbolicLink -Path $profile.CurrentUserAllHosts -Value $(Resolve-Path ./profile.ps1) -Force

# Install Chocolatey DSC Resource
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-PackageProvider -Name Chocolatier -Force
Install-PackageProvider -Name ChocolateyGet -Force
Install-Module -Name cchoco -Force
Install-Module -Name ComputerManagementDsc -Force

# Configure LCM
. .\Configurations\LCM_Config.ps1
Set-DscLocalConfigurationManager .\LCMConfig\ -Verbose

Write-Host "Installing ${$Profiles.Count()} Profiles: $profiles"
# Compile DSC Resources
Foreach ($Profile in $Profiles) {
  Write-Host "Activating $Profile profile"
  . ".\Configurations\$profile.ps1"

  # Apply Configuration
  Start-DscConfiguration -Path ".\$Profile" -Wait -Force -Verbose
}
