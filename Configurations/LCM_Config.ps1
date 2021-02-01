[DSCLocalConfigurationManager()]
configuration LCMConfig
{
  Node localhost
  {
    Settings {
      RebootNodeIfNeeded = $true
    }
  }
}

LCMConfig
