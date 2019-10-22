// Thanks to https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform
// for the guidance here!

////////////////////////////////////////////
// GCP Compute Engine webserver resources //
////////////////////////////////////////////

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// Provisioning a single Google Cloud Engine webserver instance
resource "google_compute_instance" "gcp-multicloud-instance" {
  name         = "multicloud-demo-flask-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Bootstrapping instance with Flask installed
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      // Including this section to give the VM an external ip address
    }
  }

  metadata = {
    ssh-keys = "<insert username>:ssh-rsa <public ssh string> <insert username again>"
  }
}

// Opening port 5000 for public access to Flask app; limiting SSH and RDP access
// (these are pretty permissive by default)
resource "google_compute_firewall" "flask-global-access" {
  name    = "flask-app-firewall-flask-global-access"
  network = "default"
  source_ranges = ["0.0.0.0/0"]
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
}

resource "google_compute_firewall" "ssh-home-access" {
  name    = "flask-app-firewall-ssh-home-access"
  network = "default"
  source_ranges = ["<development IPv4 address>/32"]
  priority = 1500

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

resource "google_compute_firewall" "ssh-rdp-global-deny" {
  name    = "flask-app-firewall-ssh-rdp-global-deny"
  network = "default"
  source_ranges = ["0.0.0.0/0"]
  priority = 2000

  deny {
    protocol = "tcp"
    ports = ["22", "3389"]
  }
}

// An output variable for extracting the external ip of the instance
output "gcp_multicloud_ssh_ip" {
  value = "${google_compute_instance.gcp-multicloud-instance.network_interface.0.access_config.0.nat_ip}"
}
