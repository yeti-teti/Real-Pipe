resource "google_container_cluster" "gke-node" {
  name = "${var.project_id}-gke"
  location = var.region

  enable_autopilot = true

  release_channel {
    channel = "REGULAR"
  }

  network = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet_private.id

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "172.16.0.32/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
      display_name = "Allowed From Anywhere for Setup"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {

    service_account = google_service_account.aegis-sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    #   "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
    }
    tags = ["gke-node", "${var.project_id}-gke"]
  }
}