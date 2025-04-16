resource "google_storage_bucket" "my_bucket" {
  name          = var.gcp_bucket_name
  location      = var.gcp_location
  force_destroy = true

  public_access_prevention = "enforced"
}