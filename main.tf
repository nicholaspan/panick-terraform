provider "google" {
  version = "3.5.0"

  credentials = file("network-playground-key.json")

  project = "network-playground-273716"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_subnetwork" "us-central1-subnetwork-dmz" {
    name =          "dmz-us-central1-terraform"
    ip_cidr_range = "10.10.0.0/20"
    region =        "us-central1"
    network =       google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "us-central1-subnetwork-int" {
    name =          "int-us-central1-terraform"
    ip_cidr_range = "10.8.0.0/20"
    region =        "us-central1"
    network =       google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "us-central1-subnetwork-mgmt" {
    name =          "mgmt-us-central1-terraform"
    ip_cidr_range = "10.6.0.0/26"
    region =        "us-central1"
    network =       google_compute_network.vpc_network.name
}

resource "google_compute_network" "vpc_network" {
  name = "production-network-dmz-int-mgmt"
  auto_create_subnetworks = false
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.us-central1-subnetwork-dmz.name
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}
