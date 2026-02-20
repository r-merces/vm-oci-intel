terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu_24_04" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_network_security_groups" "svc_ssh" {
  compartment_id = var.compartment_ocid
  display_name   = "svc-ssh"
}

resource "oci_core_instance" "ubuntu_micro" {
  # Seleciona o primeiro AD disponível (em regiões com múltiplos ADs, pode-se ajustar)
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "ubuntu-micro-vm"

  create_vnic_details {
    subnet_id = var.subnet_ocid
    # Vincula o Network Security Group "svc-ssh" à placa de rede
    nsg_ids   = [data.oci_core_network_security_groups.svc_ssh.network_security_groups[0].id]
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu_24_04.images[0].id
    source_type = "image"
  }

  metadata = {
    # Chave SSH pública providenciada para o usuário default (ubuntu)
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqlxyLKs39qC/gdkYqPrDPQVhDQaGF7s20tOeGKrHaslfNpX7fC867jvtyMiMHUmvG2gD3uBKwdHS9tX6a6MClrmXcWGptzQfm1f9V00BM8CPRkTXe5a/LMABRJ2z4/Yb4R4JhPYFplmJXyCflAyHKALioO3TmZjrJ8GlqbLfhD6eBvZ8HirFKNPy8vMW5V4QW9pJf12wruHm4pZi7wqMkGQwkjTc46berrG4TSjH10uvocs0aREkghuduIjit2YmdXRaqUi6pFIpaBla+QrBR7uOCL0clilFlV3ZZMogBy9JTLQnLg40cMYfoVCwhwaicbM7G+JDRb+e9DMaGh3LRo8UvjDlIXCzukYV7M+idRhWDPH5MugN0yxa4UiBQmgVApDTotlSg1AkEzn169eO7s787G6sJDDTs66aw2aBgNXOsHyzYXjc/JObJeQBJV7OmF7PSeN+hv2XyyID4n5JwzOQhPCpijM0ZKnUMIsYA0myELXiD5Ceopv48KRpuobU= rmerces@HAL"
  }
}
