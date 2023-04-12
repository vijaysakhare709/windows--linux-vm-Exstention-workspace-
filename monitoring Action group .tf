resource "azurerm_monitor_action_group" "email_alert" {
  name                = "email-alert"
  resource_group_name = azurerm_resource_group.vijay.name
  short_name          = "email-alert"


  email_receiver {
    name          = "send-email-alert"
    email_address = "vijaysakhare709@gmail.com"
    use_common_alert_schema = true
  }

  depends_on = [
    azurerm_resource_group.vijay
  ]

}

resource "azurerm_monitor_metric_alert" "Network_threshold_alert" {
  name                = "Network_threshold_alert"
  resource_group_name = azurerm_resource_group.vijay.name
  scopes              = [azurerm_windows_virtual_machine.vijhellaymahcine-1.id]
  description         = "The alert will be sent if the Network out bytes exceeds"
  
  #  # google pe search karna "Supported metrics with Azure Monitor"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"  # google pe search karna "Supported metrics with Azure Monitor"
    metric_name      = "Network Out Total"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 70 
    
    }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }

  depends_on = [
    azurerm_windows_virtual_machine.vijhellaymahcine-1,
    azurerm_monitor_action_group.email_alert
  ]
}


resource "azurerm_monitor_activity_log_alert" "virtual_machine_operation" {
  name                = "virtual-machine-operation"
  resource_group_name = azurerm_resource_group.vijay.name
  scopes              = [azurerm_resource_group.vijay.id]
  description         = "This alert will be sent if the virtual machine is deallocated"

  criteria {
    resource_id    = azurerm_windows_virtual_machine.vijhellaymahcine-1.id
    operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id

  }

  depends_on = [
    azurerm_windows_virtual_machine.vijhellaymahcine-1,
    azurerm_monitor_action_group.email_alert
  ]
}



