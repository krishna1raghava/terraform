provider "azurerm" {
  features {}
  client_id       = "5aa1f59c-d895-4d6b-84e9-b1d0bd59db44"
  client_secret   = "Iud8Q~pRxf1Rxu5NJw~Ohoipzh4-PnurzLVGaagt"
  tenant_id       = "ac122546-8756-46b9-bbe3-ee0122fe75a2"
  subscription_id = "79970236-6f32-42cd-a0f5-85bf761674df"

}
resource "azurerm_resource_group" "example" { 
        name = "example" 
        location = "South India" 
  } 

 resource "azurerm_virtual_network" "example" { 
        name            =   "example-vnet" 
        address_space   =   ["10.0.0.0/16"]
        location        =    azurerm_resource_group.example.location 
        resource_group_name  = azurerm_resource_group.example.name 
   } 
   
   resource  "azurerm_subnet" "example"  { 
          name         =  "internal" 
          resource_group_name  = azurerm_resource_group.example.name 
          virtual_network_name = azurerm_virtual_network.example.name
          address_prefixes     = ["10.0.2.0/24"]
          } 

     resource "azurerm_public_ip" "example" { 
              name          =   each.value.ip_name 
              resource_group_name  = azurerm_resource_group.example.name
              location    =          azurerm_resource_group.example.location 
              allocation_method      = "Static" 
              for_each       =      var.vm 
      } 


      resource "azurerm_network_interface" "example" { 
                name        = each.value.nic_name 
                location    = azurerm_resource_group.example.location 
                resource_group_name  = azurerm_resource_group.example.name 
                for_each  = var.vm 
          ip_configuration { 
                 name               =   "internal" 
                 subnet_id          =   azurerm_subnet.example.id 
                 private_ip_address_allocation  = "Dynamic" 
                 public_ip_address_id       = azurerm_public_ip.example[each.key].id
    
         }

           }
      resource "azurerm_network_security_group" "example" { 
                   name    = "acceptanceTestSecurityGroup1" 
                   location  = azurerm_resource_group.example.location 
                   resource_group_name = azurerm_resource_group.example.name 
              security_rule { 
              name  = "test123" 
              priority  = 100
              direction  = "Inbound" 
              access      = "Allow" 
              protocol     = "Tcp" 
              source_port_range    = "*" 
              destination_port_ranges  = ["22", "80", "443"]
              source_address_prefix    = "*" 
              destination_address_prefix  = "*" 
    } 

} 


         
                  resource "azurerm_network_interface_security_group_association" "example" { 
                         network_interface_id  = azurerm_network_interface.example[each.key].id 
                         network_security_group_id  = azurerm_network_security_group.example.id 
                         for_each = var.vm 

 } 

         
               resource "azurerm_linux_virtual_machine" "example" { 
                      name = each.value.vm_name 
                      resource_group_name = azurerm_resource_group.example.name 
                      location    = azurerm_resource_group.example.location 
                      size   = "Standard_F2"
                      computer_name = "hostname-${each.value.vm_name}"
                      admin_username    = "adminuseer" 
                      admin_password  =   "Windows@12345" 
                      disable_password_authentication    = false 
                      for_each   = var.vm 
                      network_interface_ids  = [ 
                           azurerm_network_interface.example[each.key].id,
                             ]
                     os_disk { 
                         name = "osdisk-${each.value.vm_name}"
                         caching      = "ReadWrite" 
                         storage_account_type  = "Standard_LRS" 

                     }
 
                       source_image_reference { 
                          publisher = "Canonical" 
                          offer     = "0001-com-ubuntu-server-jammy" 
                          sku       = "22_04-lts" 
                          version  = "latest" 



                       }                


 } 










  
                           
                      
























                        
 
        
            