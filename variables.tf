variable "network" {
  type = map(string)
  default = {
    name        = "myNetwork"
    region      = "GRA9"
    subnet_cidr = "192.168.12.0/24"
    subnet_name = "mySubnet"
  }
}

variable "ovh" {
  type = map(string)
  default = {
    endpoint = "ovh-eu"
  }
  # The other credentials are loaded with `source OVH_secrets.sh`
}

variable "openstack" {
  type = map(string)
  default = {
    auth_url = "https://auth.cloud.ovh.net/v3.0/"
  }
  # The other credentials are loaded with `source openrc.sh`
}

variable "product" {
  type = map(any)
  default = {
    description = "TF-techlab-private-db"
    engine     = "mongodb"
    #project_id = "<PUBLIC_CLOUD_PROJECT_ID>" # OS_TENANT_ID
    project_id = "61fc4602634148acae0426ace8e1b2a0" # OS_TENANT_ID
    region     = "GRA"
    plan       = "production"
    flavor     = "db2-2"
    user       = "mongouser"
    version    = "6.0"
  }
}