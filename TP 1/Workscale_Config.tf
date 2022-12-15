variable "project_id" {
  type = string
  default = "06881b56-5d13-4795-affa-1a72f2bfc42b"
  description = "Project_ID"
}

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
  access_key = "SCWT7A2VFAY82686YYVN"
  secret_key = "3b21afe1-bce0-4cea-bd5e-d591e9fefba2"
}

resource "scaleway_instance_ip" "public_ip" {
  project_id = var.project_id
}


resource "scaleway_instance_server" "web" {
  project_id = var.project_id
  type = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.public_ip.id
}

resource "scaleway_instance_ip" "slave_ip" {
  project_id = var.project_id
}


resource "scaleway_instance_server" "slave" {
  project_id = var.project_id
  type = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.slave_ip.id
}