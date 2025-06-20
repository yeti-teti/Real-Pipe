# Service account
resource "google_service_account" "aegis-sa" {
  account_id = var.service_account_id
  display_name = "Aegis Infra"
}

# IAM Binding for Service Account

resource "google_project_iam_binding" "monitoring-viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
}

resource "google_project_iam_binding" "logging-writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
}

resource "google_project_iam_binding" "artifact-reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
}

# resource "google_project_iam_binding" "storage-admin" {
#   project = var.project_id
#   role = "roles/storage.admin"
#   members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
#   depends_on = [ google_service_account.aegis-sa ]
# }

# resource "google_project_iam_binding" "compute-admin" {
#   project = var.project_id
#   role = "roles/compute.admin"
#   members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
#   depends_on = [ google_service_account.aegis-sa ]
# }

# resource "google_project_iam_binding" "container-admin" {
#   project = var.project_id
#   role = "roles/container.admin"
#   members = ["serviceAccount:${google_service_account.aegis-sa.email}"]
#   depends_on = [ google_service_account.aegis-sa ]
# }