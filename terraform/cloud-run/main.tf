resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project  = var.project_id
  service  = each.key
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repository_id
  format        = "DOCKER"
  depends_on    = [google_project_service.gcp_services]
}

locals {
  artifact_image_name = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.service_name}:${var.image_tag}"
}

resource "null_resource" "auth_docker" {
  provisioner "local-exec" {
    command = "gcloud auth configure-docker ${var.region}-docker.pkg.dev"
  }
}

resource "null_resource" "build_image" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command     = "docker build --platform ${var.build_platform} -t ${local.artifact_image_name} ../../apps/backend/"
    working_dir = path.module
  }
  depends_on = [null_resource.auth_docker, google_artifact_registry_repository.repo]
}

resource "null_resource" "push_image" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "docker push ${local.artifact_image_name}"
  }
  depends_on = [null_resource.build_image]
}

resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    containers {
      image = local.artifact_image_name
      ports {
        container_port = var.port
      }
    }
  }
  depends_on = [null_resource.push_image, google_project_service.gcp_services]
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.service.name
  location = google_cloud_run_v2_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
