terraform {
  backend "gcs" {
    bucket = "aegis-bucket"
    prefix = "terraform.tfstate"
  }
}