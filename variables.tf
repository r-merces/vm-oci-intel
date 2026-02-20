variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user"
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint for the API key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the OCI API private key file"
  type        = string
}

variable "region" {
  description = "The OCI region"
  type        = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment"
  type        = string
}

variable "subnet_ocid" {
  description = "The OCID of the subnet"
  type        = string
}
