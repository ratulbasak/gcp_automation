variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (e.g., us-central1)"
  type        = string
  default     = "europe-west3"
}

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com"
  ]
}

variable "repository_id" {
  description = "Artifact Registry repository ID"
  type        = string
  default     = "fastapi-repo"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "fastapi-service"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "port" {
  description = "Container Port"
  type        = number
  default     = 8000
}

variable "build_platform" {
  description = "Docker build platform"
  type        = string
  default     = "linux/amd64"
}
