#purpose - reusable configurations
#gcp project id

variable "project_id" {
    description = "Your GCP project id"
    type = string
}

#region

variable "region" {
    description = "gcp region"
    default = "us-central1"
}