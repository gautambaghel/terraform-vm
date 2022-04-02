terraform {

  cloud {
    organization = "tfc-integration-sandbox"

    workspaces {
      name = "terraform-vm"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  required_version = ">= 0.14.9"
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Azure -- Deploy Linux VM
resource "azurerm_linux_virtual_machine" "az_linux_vm" {
  name                = "az_linux_vm-machine"
  resource_group_name = "virtual-machines"
  location            = "West US 2"
  size                = "Standard_F2"
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Azure -- Deploy Windows VM
resource "azurerm_windows_virtual_machine" "az_windows_vm" {
  name                = "az_windows_vm-machine"
  resource_group_name = "virtual-machines"
  location            = "West US 2"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


# AWS -- Deploy EC2
resource "aws_instance" "aws_ec2_vm" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}