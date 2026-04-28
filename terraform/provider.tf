#configure google cloud provider - connecting terraform to GCP

provider "google" {
    project = var.project_id #GCP project_id
    region = var.region #default region
}