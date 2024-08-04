variable "vm" { 
    type  = map(object({
       
       vm_name  = string 
       nic_name = string 
       ip_name  = string 
    }))
        default  = {  
           vm1 = { 
            vm_name = "master" 
            nic_name  = "master-nic" 
            ip_name  = "master-ip" 
          } 
           vm2 = { 
            vm_name = "workednode1" 
            nic_name  = "workernode1-nic" 
            ip_name  = "workernode1-ip" 
          } 

            vm3 = { 
            vm_name = "workednode2" 
            nic_name  = "workednode2-nic" 
            ip_name  = "workednode2-ip" 
          } 
        }
}
