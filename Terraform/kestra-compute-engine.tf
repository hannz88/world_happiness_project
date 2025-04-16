module "gce-container" {
  source = "terraform-google-modules/container-vm/google"
  version = "~> 3.2"

  container = {
    image = "kestra/kestra:v0.21.12"
    args = [
      "server",
      "standalone"
    ]
    env = [
      {
        name = "KESTRA_CONFIGURATION"
        value = <<EOT
datasources:
  postgres:
    url: jdbc:postgresql://${google_sql_database_instance.kestra_db_instance.private_ip_address}:5432/kestra
    driverClassName: org.postgresql.Driver
    username: ${google_sql_user.users.name}
    password: ${google_sql_user.users.password}
kestra:
  server:
    basicAuth:
      enabled: false
      username: ${var.personal_email} # it must be a valid email address
      password: ${var.personal_password}
  repository:
    type: postgres
  storage:
    type: local
    local:
      basePath: "/app/storage"
  queue:
    type: postgres
  tasks:
    tmpDir:
      path: "/cache"
  url: "http://0.0.0.0:80/"
EOT
      }
    ],
    # Declare volumes to be mounted.
    # This is similar to how docker volumes are declared.
    volumeMounts = [
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = false
      },
      {
        mountPath = "/app/storage"
        name      = "data-disk-0"
        readOnly  = false
      },
    ]
    depends_on = [google_sql_user.users]
  }

  # Declare the Volumes which will be used for mounting.
  volumes = [
    {
      name = "tempfs-0"

      emptyDir = {
        medium = "Memory"
      }
    },
    {
      name = "data-disk-0"

      gcePersistentDisk = {
        pdName = "data-disk-0"
        fsType = "ext4"
      }
    },
  ]
  restart_policy = "Always"
}

resource "google_compute_disk" "pd" {
  project = var.gcp_project_id
  name    = "${var.gcp_kestra_vm_instance}-data-disk"
  type    = "pd-ssd"
  zone    = var.gcp_zone
  size    = 10
}

resource "google_compute_instance" "vm" {
  allow_stopping_for_update = true
  project      = var.gcp_project_id
  name         = var.gcp_kestra_vm_instance
  machine_type = "n2-highcpu-2"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  attached_disk {
    source      = google_compute_disk.pd.self_link
    device_name = "data-disk-0"
    mode        = "READ_WRITE"
    }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["kestra" , "http-server"]

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    startup-script = "#!/bin/bash \nsudo chmod a+w /mnt/disks/gce-containers-mounts/gce-persistent-disks/data-disk-0/"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = google_service_account.service_account.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  depends_on = [google_sql_database_instance.kestra_db_instance]
}