#----------------------------------------------------------------creating host aggregate----------------------------------------

resource "openstack_compute_aggregate_v2" "my-host-aggregate" {
  region = "RegionOne"
  name   = var.host_aggregate["name"]
  zone   = var.host_aggregate["zone"]    

  hosts = [
    "compute",
   ]
}

#--------------------------------------------------creating flavor-------------------------------------------------
resource "openstack_compute_flavor_v2" "test-flavor" {
  name  = var.flavor["name"]
  ram   = var.flavor["ram"]
  vcpus = var.flavor["vcpus"]
  disk  = var.flavor["disk"]
#  is_public = var.flavor["public_access"]
}

#-------------------------------------------------------creating image----------------------------------------------------------------
resource "openstack_images_image_v2" "test-image" {
  name             = var.image["name"]
  image_source_url = var.image["source_url"]
  disk_format      = "qcow2"
  container_format = "bare"
  visibility       = "public"

  properties = {
    key = "value"
  }
}

#---------------------------------------------------network-------------------------------------------------------------

resource "openstack_networking_network_v2" "provider" {
  name           = var.network["name"]
  admin_state_up = "true"
  shared         = "true"
  external       = "true"
  segments {
    network_type     = "flat"
    physical_network = var.network["name"]
  }
}

#---------------------------------------------------network-subnet-------------------------------------------------------------
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = var.network_subnet["name"]
  network_id = openstack_networking_network_v2.provider.id
  cidr       = var.network_subnet["cidr"]
  ip_version = "4"  
  gateway_ip      = var.network_subnet["gateway_ip"]
  dns_nameservers = var.network_subnet["dns_nameservers"]

  allocation_pool {
    start = var.network_subnet.allocation_pool["start"]
    end   = var.network_subnet.allocation_pool["end"]
  }


}

#---------------------------------------------------Security Group-------------------------------------------------------------
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = var.secgroup["name"]
  description = var.secgroup["description"]

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr     = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

#---------------------------------------------------instance 1 creation -------------------------------------------------------------
resource "openstack_compute_instance_v2" "instance_1" {
  name            = var.instance["name1"]
  image_id        = openstack_images_image_v2.test-image.id
  flavor_id       = openstack_compute_flavor_v2.test-flavor.id
  security_groups = [openstack_compute_secgroup_v2.secgroup_1.name]

  network {
    name = openstack_networking_network_v2.provider.name
  }
}


#---------------------------------------------------volume-creation-------------------------------------------------------------

resource "openstack_blockstorage_volume_v2" "volume_1" {
  region      = var.volume["region"]
  name        = var.volume["name"]
  description = var.volume["description"]
  size        = var.volume["size_in_GB"]
  availability_zone = var.volume["availability_zone"]
}


#----------------------------- Attaching single volume to a single instance----------------------------------------------------

resource "openstack_compute_volume_attach_v2" "attached1" {
  instance_id = openstack_compute_instance_v2.instance_1.id
  volume_id   = openstack_blockstorage_volume_v2.volume_1.id
}

#------------------------------Creating filesystem, Mounting volume to instance_1 and Adding sample Data------------------------------------

resource "null_resource" "format_volume_instance1" {
  triggers = {
    volume_id = openstack_blockstorage_volume_v2.volume_1.id
  }
  connection {
    type        = "ssh"
    user        = "cirros"   # Replace with the SSH user for the first instance
   #private_key = file("/home/ubuntu/.ssh/authorized_keys")  # Replace with the path to your private key
    password    = "gocubsgo"
    host        = openstack_compute_instance_v2.instance_1.access_ip_v4  # IP of the first instance
  }

  provisioner "remote-exec" {
    inline = [
      # Format the volume (assuming it's /dev/vdb)
      "sudo mkfs -t ext4 /dev/vdb",      
      # Mount the volume
      "sudo mount -t ext4 /dev/vdb /opt",
      # Add data to the volume
      "sudo echo 'testing only ' | sudo tee /opt/sample_data.txt",
     
    ]
  }

  depends_on = [openstack_compute_volume_attach_v2.attached1]
}


#-----------------------------------------------creating instance 2 -----------------------------------------------------
resource "openstack_compute_instance_v2" "instance_2" {
  name            = var.instance["name2"]
  image_id        = openstack_images_image_v2.test-image.id
  flavor_id       = openstack_compute_flavor_v2.test-flavor.id
  security_groups = [openstack_compute_secgroup_v2.secgroup_1.name]

  network {
    name = openstack_networking_network_v2.provider.name
  }
}

#
#----------------------------------------detaching volume from first instance instance_1---------------------
#resource "openstack_compute_volume_detach_v2" "detach_from_instance1" {
#  instance_id = openstack_compute_instance_v2.instance_1.id
#  volume_id   = openstack_blockstorage_volume_v2.volume_1.id
#}
#

#-----------------------------------------------attaching volume to instance 2---------------------------

#resource "openstack_compute_volume_attach_v2" "attach_to_instance2" {
#  instance_id = openstack_compute_instance_v2.instance_2.id
#  volume_id   = openstack_blockstorage_volume_v2.volume_1.id
#}

