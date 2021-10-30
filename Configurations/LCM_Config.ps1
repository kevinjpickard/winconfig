[DSCLocalConfigurationManager()]
configuration LCMConfig
{
  Node localhost
  {
    Settings {
      RebootNodeIfNeeded = $true
      ConfigurationMode = ApplyOnly
    }
  }
}

LCMConfig
