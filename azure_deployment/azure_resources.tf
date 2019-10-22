//////////////////////////////////////////
// Azure multicloud demo infrastructure //
//////////////////////////////////////////

// We'll place all our Azure resources in an example Resource Group
resource "azurerm_resource_group" "multicloud-rg" {
  name     = "multicloud_terraform_azure_rg"
  location = "southcentralus"
}

// Defining the 'plan' to use with our App Service below
// (staying economical with Free Tier resources)
resource "azurerm_app_service_plan" "multicloud-sp" {
  name                = "multicloud-appserviceplan"
  location            = "${azurerm_resource_group.multicloud-rg.location}"
  resource_group_name = "${azurerm_resource_group.multicloud-rg.name}"

  sku {
    tier = "Free"
    size = "F1"
  }
}

// Provisioning a basic App Service (like AWS Elastic Beanstalk)
// that we can query via HTTP/DNS
resource "azurerm_app_service" "multicloud-test-appservice" {
  name                = "<your appservice name>"
  location            = "${azurerm_resource_group.multicloud-rg.location}"
  resource_group_name = "${azurerm_resource_group.multicloud-rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.multicloud-sp.id}"
}
