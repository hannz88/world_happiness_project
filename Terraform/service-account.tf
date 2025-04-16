resource "google_service_account" "service_account" {
  account_id   = var.gcp_service_account_id
  display_name = var.gcp_service_account_id
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}