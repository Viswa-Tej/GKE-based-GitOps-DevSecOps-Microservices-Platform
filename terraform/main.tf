resource "google_compute_instance" "vm" {
    name = "devsecops-vm"
    machine_type = "e2-small"
    zone = "${var.region}-a"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
            size = 10
            type = "pd-standard"
        }
    }
    network_interface {
        network = "default"
        access_config { } #public IP
    }
    
}