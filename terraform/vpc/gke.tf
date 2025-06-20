# Bastion resource for GKE
resource "google_compute_address" "bastion_static_ip"{
  project = var.project_id
  name = "${var.project_id}-bastion-static-ip"
  region = var.region
}

resource "google_compute_instance" "bastion" {
  project = var.project_id
  name = "${var.project_id}-bastion-vm-gke"
  machine_type = "e2-medium"
  zone = var.zone
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet_public.self_link
    access_config {
      nat_ip = google_compute_address.bastion_static_ip.address
    }
  }

  tags                    = ["bastion"]
  metadata_startup_script = <<-EOT
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get update && sudo apt-get install -y google-cloud-cli kubectl
  EOT

  service_account {
    email  = google_service_account.aegis-sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

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
      cidr_block   = "10.20.0.0/24"
      display_name = "private-subnet"
    }
    cidr_blocks {
      cidr_block   = google_compute_subnetwork.subnet_public.ip_cidr_range
      display_name = "public-subnet-for-bastion"
    }
  }

  # workload_identity_config {
  #   workload_pool = "${var.project_id}.svc.id.goog"
  # }

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