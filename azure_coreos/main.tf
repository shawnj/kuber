variable "admin_username" {
  description = "administrator user name"
  default     = ""
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
}

variable "client_id" {
  description = ""
}

variable "client_secret" {
  description = ""
}

variable "subscription_id" {
  description = ""
}

variable "tenant_id" {
  description = ""
}

variable "resource_group" {
  default = "TestCore"
}

variable "location" {
  default = "westus"
}

variable "virtual_network_name" {
  default = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.2.0/24"
}

variable "rg_prefix" {
  default = "tc"
}

variable "hostname" {
  default = "TestCoreOSVM"
}

locals {
  
}


provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "testcoresj" {
  name                     = "testcoresj"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_resource_group.rg"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.subnet_prefix}"
}

resource "azurerm_public_ip" "corepip" {
  name                         = "${var.rg_prefix}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Static"
  domain_name_label            = "${lower("${var.hostname}corepip")}"
}

resource "azurerm_lb" "lbtest" {
  name                = "TestLoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.corepip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "test" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lbtest.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.lbtest.id}"
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.test.id}"
  probe_id                       = "${azurerm_lb_probe.test.id}"
}

resource "azurerm_lb_probe" "test" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.lbtest.id}"
  name                = "http"
  port                = 80
}

resource "azurerm_availability_set" "test" {
  name                = "acceptanceTestAvailabilitySet1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed = true
  depends_on          = ["azurerm_resource_group.rg"]

  tags {
    environment = "Production"
  }
}

## Need to create an availability Set and a LB and Backend Pool for AzureLinuxVM's
module "azure_coreos1" {
  source = "github.com/shawnj/terraform//modules/azurelinuxvm"

  image_offer     = "CoreOS"
  image_sku       = "Stable"
  image_publisher = "CoreOS"
  image_version   = "latest"

  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"
  disable_password = true
  ssh_key          = "${file("keydata.key")}"
  dns_name         = "${lower("${var.hostname}1dns")}"

  custom_data = "${file("ignition.json")}"

  availability_set = "${azurerm_availability_set.test.id}"

  backend_pool_ids = "${azurerm_lb_backend_address_pool.test.id}"

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  hostname       = "${var.hostname}1"
  resource_group = "${azurerm_resource_group.rg.name}"
  location       = "${var.location}"
  rg_prefix      = "${var.rg_prefix}1"

  subnet_id = "${azurerm_subnet.subnet.id}"
}

module "azure_coreos2" {
  source = "github.com/shawnj/terraform//modules/azurelinuxvm" 

  image_offer     = "CoreOS"
  image_sku       = "Stable"
  image_publisher = "CoreOS"
  image_version   = "latest"

  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"
  disable_password = true
  ssh_key          = "${file("keydata.key")}"
  dns_name         = "${lower("${var.hostname}2dns")}"

  custom_data = "${file("ignition.json")}"

  availability_set = "${azurerm_availability_set.test.id}"

  backend_pool_ids = "${azurerm_lb_backend_address_pool.test.id}"

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  hostname       = "${var.hostname}2"
  resource_group = "${azurerm_resource_group.rg.name}"
  location       = "${var.location}"
  rg_prefix      = "${var.rg_prefix}2"

  subnet_id = "${azurerm_subnet.subnet.id}"
}

module "azure_coreos3" {
  source = "github.com/shawnj/terraform//modules/azurelinuxvm" 

  image_offer     = "CoreOS"
  image_sku       = "Stable"
  image_publisher = "CoreOS"
  image_version   = "latest"

  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"
  disable_password = true
  ssh_key          = "${file("keydata.key")}"
  dns_name         = "${lower("${var.hostname}3dns")}"

  custom_data = "${file("ignition.json")}"

  availability_set = "${azurerm_availability_set.test.id}"

  backend_pool_ids = "${azurerm_lb_backend_address_pool.test.id}"

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  hostname       = "${var.hostname}3"
  resource_group = "${azurerm_resource_group.rg.name}"
  location       = "${var.location}"
  rg_prefix      = "${var.rg_prefix}3"

  subnet_id = "${azurerm_subnet.subnet.id}"
}

module "azure_coreos4" {
  source = "github.com/shawnj/terraform//modules/azurelinuxvm" #

  image_offer     = "CoreOS"
  image_sku       = "Stable"
  image_publisher = "CoreOS"
  image_version   = "latest"

  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"
  disable_password = true
  ssh_key          = "${file("keydata.key")}"
  dns_name         = "${lower("${var.hostname}4dns")}"

  custom_data = "${file("ignition.json")}"

  availability_set = "${azurerm_availability_set.test.id}"

  backend_pool_ids = "${azurerm_lb_backend_address_pool.test.id}"

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  hostname       = "${var.hostname}4"
  resource_group = "${azurerm_resource_group.rg.name}"
  location       = "${var.location}"
  rg_prefix      = "${var.rg_prefix}4"

  subnet_id = "${azurerm_subnet.subnet.id}"
}

module "azure_win" {
  source = "github.com/shawnj/terraform//modules/azurewinvm"

  #image_offer     = "CoreOS"
  #image_sku       = "Stable"
  #image_publisher = "CoreOS"
  #image_version   = "latest"

  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"

  #custom_data = "${file("ignition.json")}"
  dns_name = "${lower("${var.hostname}windns")}"

  #availability_set = "${azurerm_availability_set.test.id}"

  #backend_pool_ids = "${azurerm_lb_backend_address_pool.test.id}"

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  hostname       = "${var.hostname}win"
  resource_group = "${azurerm_resource_group.rg.name}"
  location       = "${var.location}"
  rg_prefix      = "${var.rg_prefix}win"

  subnet_id = "${azurerm_subnet.subnet.id}"
}