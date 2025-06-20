# Create new storage bucket
resource "google_storage_bucket" "static" {
  name = "aegis-bucket"
  location = "US"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
}