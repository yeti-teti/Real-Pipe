terraform {
  backend "gcs" {
    bucket = "aegis-bucket"
    prefix = "dev/terraform.tfstate"
  }
}