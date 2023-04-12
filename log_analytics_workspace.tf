resource "azurerm_log_analytics_workspace" "vmworkspace" {
  name                = "vmworkspace"
  location            = azurerm_resource_group.vijay.location
  resource_group_name = azurerm_resource_group.vijay.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [
    azurerm_resource_group.vijay
  ]
}

# isse virtual machine workspace ke sath connet hongi

resource "azurerm_virtual_machine_extension" "vmagent" {

  name                 = "vmagent"
  virtual_machine_id   = azurerm_windows_virtual_machine.vijhellaymahcine-1.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
  {
    "workspaceId": "${azurerm_log_analytics_workspace.vmworkspace.workspace_id}"
  }
SETTINGS  
  protected_settings = <<PROTECTED_SETTINGS
  {
    "workspaceKey": "${azurerm_log_analytics_workspace.vmworkspace.primary_shared_key}"
  }
PROTECTED_SETTINGS

depends_on = [
  azurerm_log_analytics_workspace.vmworkspace,
  azurerm_windows_virtual_machine.vijhellaymahcine-1
]

}

# ye window virtaul machine ka event log the jo workspace mai bheja hai

resource "azurerm_log_analytics_datasource_windows_event" "systemevents" {
  name                = "systemevents"
  resource_group_name = azurerm_resource_group.vijay.name
  workspace_name      = azurerm_log_analytics_workspace.vmworkspace.name
  event_log_name      = "System"
  event_types         = ["Information"]

  depends_on = [
  azurerm_log_analytics_workspace.vmworkspace,
  azurerm_resource_group.vijay
]


}



/*
# linux virtual machine extension for monitor 
resource "azurerm_virtual_machine_extension" "linux_monitoring_extension" {

  name                 = "LinuxMonitoringExtension"
  virtual_machine_id   = azurerm_linux_virtual_machine.vijhellaymahcine-1.id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorLinuxAgent"
  type_handler_version = "1.0"

  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = "true"

  settings = <<SETTINGS
  {
    "workspaceId": $"{azurerm_log_analytics_workspace.vmworkspace.workspace_id}",
    "stopOnMultipleConnections": true,
    "config": {
      "logAnalytics": {
        "workspaceKey": $"{azurerm_log_analytics_workspace.vmworkspace.primary_shared_key}",
        "maxBatchSize": 4096,
        "maxSecondsBeforeFlush": 30,
        "syslogEvents": {
          "syslogFacility": "local0",
          "syslogPriority": "notice"
        }
      }
    }
  }
SETTINGS

  tags = {
    environment = "Production"
  }
}
*/
