resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.gcp_dataset
  friendly_name               = var.gcp_dataset
  description                 = "This is a test description"
  location                    = var.gcp_location

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.service_account.email
  }
}
