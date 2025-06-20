# Pub/Sub resource
resource "google_pubsub_topic" "pubsub"{
    name = "${var.project_id}-pubsub"

    message_retention_duration = "86600s"
}

# Artifact registry
resource "google_artifact_registry_repository" "aegis-repo" {
  location = var.region
  repository_id = "aegis-repo"
  description = "Aegis Docker Repo"
  format = "DOCKER"
}