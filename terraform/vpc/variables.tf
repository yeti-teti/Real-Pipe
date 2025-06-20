variable "project_id" {
  description = "GCP Project ID"
  default = "aegis-total"
}

variable "region" {
    description = "GCP Region"
    default = "us-west1"
}

variable "zone" {
  description = "GCP Zone for zonal resources"
  default = "us-west1-a"
}

variable "service_account_id" {
  description = "Service account ID"
  default = "aegis-project"
}
