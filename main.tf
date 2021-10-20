# See detail https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html

variable "usr_subscription_id" {}       # サブスクリプションID (調べる)
variable "usr_client_id" {}             # クライアントID (アプリを登録したときに自動生成される)
variable "usr_client_secret" {}         # シークレット/パスワード (サービスプリンシパルを作ったときに入力している)
variable "usr_tenant_id" {}             # テナントID (調べる)
variable "usr_region" {}                # リージョン指定
variable "usr_rg_name" {}               # リソースグループ名
variable "usr_vnet_name" {}             # 仮想ネットワーク名
variable "usr_vnet_range" {}            # 仮想ネットワークのレンジ
variable "usr_subnet_name" {}           # サブネット名
variable "usr_subnet_range" {}          # サブネットのレンジ
variable "usr_nic_name" {}              # ネットワークインターフェース名
variable "usr_pip_name" {}              # パブリックIP名
variable "usr_nsg_name" {}              # ネットワークセキュリティグループ名
variable "usr_vm_name" {}               # 仮想マシン名
variable "usr_vm_size" {}               # 仮想マシンのインスタンスサイズ
variable "usr_vm_username" {}           # 仮想マシンの管理者名
variable "usr_vm_password" {}           # 仮想マシンのパスワード

variable "usr_bastion_subnet_name" {}   # Bastion用のサブネット名
variable "usr_bastion_subnet_range" {}  # Bastion用のサブネットのレンジ
variable "usr_bastion_pip_name" {}      # Bastion用のパブリックIP名
variable "usr_bastion_name" {}          # Bastionの名前

provider "azurerm" {
  features {}
  subscription_id = var.usr_subscription_id
  client_id       = var.usr_client_id
  client_secret   = var.usr_client_secret
  tenant_id       = var.usr_tenant_id
}

resource "azurerm_resource_group" "rg_tf" {
  name     = var.usr_rg_name
  location = var.usr_region
}

resource "azurerm_virtual_network" "vnet_tf" {
  name                = var.usr_vnet_name
  address_space       = var.usr_vnet_range
  location            = azurerm_resource_group.rg_tf.location
  resource_group_name = azurerm_resource_group.rg_tf.name
}

resource "azurerm_subnet" "subnet_tf" {
  name                 = var.usr_subnet_name
  resource_group_name  = azurerm_resource_group.rg_tf.name
  virtual_network_name = azurerm_virtual_network.vnet_tf.name
  address_prefixes       = var.usr_subnet_range
}

resource "azurerm_public_ip" "pip_tf" {
    name                         = var.usr_pip_name
    location                     = azurerm_resource_group.rg_tf.location
    resource_group_name          = azurerm_resource_group.rg_tf.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "nic_tf" {
  name                = var.usr_nic_name
  location            = azurerm_resource_group.rg_tf.location
  resource_group_name = azurerm_resource_group.rg_tf.name

  ip_configuration {
    name                          = azurerm_subnet.subnet_tf.name
    subnet_id                     = azurerm_subnet.subnet_tf.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_tf.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "connectivity_tf" {
    network_interface_id      = azurerm_network_interface.nic_tf.id
    network_security_group_id = azurerm_network_security_group.nsg_tf.id
}

resource "azurerm_network_security_group" "nsg_tf" {
    name                = var.usr_nsg_name
    location            = azurerm_resource_group.rg_tf.location
    resource_group_name = azurerm_resource_group.rg_tf.name
    
    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_windows_virtual_machine" "vm_tf" {
  name                = var.usr_vm_name
  resource_group_name = azurerm_resource_group.rg_tf.name
  location            = azurerm_resource_group.rg_tf.location
  size                = var.usr_vm_size
  admin_username      = var.usr_vm_username
  admin_password      = var.usr_vm_password
  network_interface_ids = [
    azurerm_network_interface.nic_tf.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# for Bastion Provisioning
resource "azurerm_subnet" "subnet-bastion" {
  name                 = var.usr_bastion_subnet_name
  resource_group_name  = azurerm_resource_group.rg_tf.name
  virtual_network_name = azurerm_virtual_network.vnet_tf.name
  address_prefixes     = var.usr_bastion_subnet_range
}

resource "azurerm_public_ip" "pip-bastion" {
  name                = var.usr_bastion_pip_name
  location            = azurerm_resource_group.rg_tf.location
  resource_group_name = azurerm_resource_group.rg_tf.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.usr_bastion_name
  location            = azurerm_resource_group.rg_tf.location
  resource_group_name = azurerm_resource_group.rg_tf.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-bastion.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }
}
