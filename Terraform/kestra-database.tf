resource "google_sql_database" "kestra_database" {
  name     = "kestra"
  instance = google_sql_database_instance.kestra_db_instance.name
  depends_on = [google_sql_database_instance.kestra_db_instance, google_sql_user.users]
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "kestra_db_instance" {
  name             = var.gcp_database
  region           = var.gcp_region
  database_version = "POSTGRES_17"
  settings {
    tier = "db-custom-1-3840"
    edition = "ENTERPRISE"

    ip_configuration {
      ipv4_enabled = true
      private_network = data.google_compute_network.default.id
      enable_private_path_for_google_cloud_services = true
      allocated_ip_range = "services-ip-range"
      authorized_networks {
          name = "home"
          value = "188.214.10.0/24"
      }
    }
  }

  deletion_protection  = false
}

resource "google_sql_user" "users"{
  name = "kestra"
  instance = google_sql_database_instance.kestra_db_instance.name
  password = "kestra"
  depends_on = [google_sql_database_instance.kestra_db_instance]
}

