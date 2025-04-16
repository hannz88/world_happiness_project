output "service_account" {
  value = base64decode(google_service_account_key.service_account_key.private_key)
  sensitive = true
}

output "bucket" {
  value = google_storage_bucket.my_bucket.name
}