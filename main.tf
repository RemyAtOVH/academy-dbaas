terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.35.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }

  required_version = ">= 0.17.1"
}

provider "ovh" {
  endpoint = var.ovh.endpoint

  # Credentials are acquired by a previous `source OVH_secrets.sh`
}

# Configure the OpenStack Provider
provider "openstack" {
  auth_url = var.openstack.auth_url

  # Credentials are acquired by a previous `source openrc.sh`
}

resource "openstack_networking_network_v2" "my_private_network" {
  admin_state_up = "true"
  name           = var.network.name
  region         = var.network.region
}

resource "openstack_networking_subnet_v2" "my_subnet" {
  network_id      = openstack_networking_network_v2.my_private_network.id
  name            = var.network.subnet_name
  region          = var.network.region
  cidr            = var.network.subnet_cidr
  enable_dhcp     = true
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]

  allocation_pool {
    start = "192.168.12.100"
    end   = "192.168.12.200"
  }
}

resource "ovh_cloud_project_database" "service" {
  description  = var.product.description
  engine       = var.product.engine
  plan         = var.product.plan
  service_name = var.product.project_id
  version      = var.product.version
  nodes {
    region = var.product.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region = var.product.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region = var.product.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
  flavor = var.product.flavor
}


resource "ovh_cloud_project_database_mongodb_user" "new_user" {
  service_name = ovh_cloud_project_database.service.service_name
  cluster_id   = ovh_cloud_project_database.service.id
  name         = var.product.user
  roles        = ["clusterMonitor@admin"]
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.service.service_name
  engine       = ovh_cloud_project_database.service.engine
  cluster_id   = ovh_cloud_project_database.service.id
  ip           = var.network.subnet_cidr
}