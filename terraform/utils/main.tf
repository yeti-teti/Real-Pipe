# Project
provider "google"{
  project = "aegis-total"
}

# Create new storage bucket
resource "google_storage_bucket" "static" {
  name = "aegis-bucket"
  location = "us-west1"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
}
