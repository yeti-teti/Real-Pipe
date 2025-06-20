# VPC
resource "google_compute_network" "vpc" {
  name = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Public Subnet
resource "google_compute_subnetwork" "subnet_public" {
  name = "${var.project_id}-subnet-public"
  ip_cidr_range = "10.0.0.0/24"
  region = var.region
  network = google_compute_network.vpc.id
}

# Private Subnet
resource "google_compute_subnetwork" "subnet_private" {
    name = "${var.project_id}-subnet-private"
    region = var.region
    network = google_compute_network.vpc.id

    ip_cidr_range = "10.20.0.0/24"

    private_ip_google_access = true
}

# NAT Router
resource "google_compute_router" "router" {
  name = "${var.project_id}-router"
  region = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "name" {
  name = "${var.project_id}-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.subnet_private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall rule for egress to internet from nodes (via NAT)
resource "google_compute_firewall" "allow_egress_from_private_subnet" {
  name = "${var.project_id}-allow-egress-private"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags = ["gke-node"]
  direction = "EGRESS"
}
