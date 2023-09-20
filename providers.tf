/*
provider "openstack" {                                                                   # Define required providers   
  cloud = "openstack"
}
*/

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.46.0"
    }
  }
}

provider "openstack" {                                                                  # Configure required providers
  user_name = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password  = "${var.openstack_password}"
  auth_url  = "${var.openstack_auth_url}"
  region      = "RegionOne"
  project_domain_name   = "Default"
  project_domain_id = "default"  
}



 

/* 
grep -E 'USERN|PASS|TEN|AUT' /etc/kolla/admin-openrc.sh
export OS_USERNAME=admin
export OS_TENANT_NAME=admin
export OS_PASSWORD=openstackb24g
export OS_AUTH_URL=http://10.253.17.175:5000/v3/

*/




/*
provider "openstack" {				//Configure Openstack provider
  user_name   = "admin"
//  tenant_name = "admin"
  password    = "openstackb24g"
  auth_url    = "http://controller:5000/v3/"
  region      = "RegionOne"
}
*/
