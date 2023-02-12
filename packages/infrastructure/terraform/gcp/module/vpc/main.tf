## Description: This module creates a VPC in GCP
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

## Variables
variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "region" {
  type        = string
  description = "value of the region"
}

variable "gcp_project" {
  type        = string
  description = "The name of the GCP project"
}

### Outputs
output "name" {
  value = google_compute_network.vpc_network.name
}
  
output "id" {
  value = google_compute_network.vpc_network.id
}

output "self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "routing_mode" {
  value = google_compute_network.vpc_network.routing_mode
}

output "gateway_ipv4" {
  value = google_compute_network.vpc_network.gateway_ipv4
}

output "subnetworks" {
  value = google_compute_network.vpc_network.subnetworks
}