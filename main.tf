provider "google" {
  version = "3.5.0"

  credentials = file("network-playground-key.json")

  project = "network-playground-273716"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
