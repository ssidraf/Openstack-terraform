variable "openstack_user_name" {}
variable "openstack_tenant_name" {}
variable "openstack_password" {}
variable "openstack_auth_url" {}


#---------------------------------------------------------host-aggregate---------------------------------------------------------
variable "host_aggregate" {
  type    = map
  default = {
    "name" = "comp1"
    "zone" = "comp1"
  }
}

#-------------------------------------------------------------------------flavor-----------------------------------------------

variable flavor {
  type    = map
  default = {
    "name" = "flavor0"
    "ram" = "1024"
    "vcpus" = "1"
    "disk" = "1"
#	public_access = "true"	//then uncomment it.
  }
}

#---------------------------------------------------------image----------------------------------------------------------------
variable "image" {
   type    = map
  default = {
    "name" = "cirros0"
    "source_url" = "https://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img"    //can save image in vm and give local path
    }
}

#---------------------------------------------------network-------------------------------------------------------------
variable network {
	type = map
	default = {
	  "name" = "provider"
 }
}

#---------------------------------------------------network-subnet-------------------------------------------------------------
variable network_subnet {
      type = object({
      name = string
      cidr = string
      gateway_ip = string
      allocation_pool = map(string)
      dns_nameservers = list(string)
  })

  default = {
    "name"       = "provider-sub0"
    "cidr"       = "10.253.0.0/16"
    "gateway_ip" = "10.253.0.1"
    "allocation_pool" = { 
        "start" = "10.253.17.177"
        "end"  = "10.253.17.181"
    }
    "enable_dhcp" = "true" 
    "dns_nameservers" = ["10.254.4.10"]
  }
}

#---------------------------------------------------Security Group-------------------------------------------------------------
variable secgroup {
   type = map
   default = {
	  "name" = "security_group0"
    "description" = "Default security group"
 }
}

#---------------------------------------------------instance-------------------------------------------------------------
variable instance {
	type = map
	default = {
	  "name1" = "instance0"
	  "name2" = "instance1"
  }
}

#---------------------------------------------------volume-------------------------------------------------------------
variable volume {
	type = map
	default = {
	  "region" = "RegionOne"
	  "name" = "volume0"
	  "size_in_GB" = "1"
	  "availability_zone" = "vol-comp1"
	  "description" = "terraform created volume"
 }	
}

