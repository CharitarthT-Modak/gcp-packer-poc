# main.pkr.hcl
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "ubuntu" {
  project_id          = var.project_id
  # source_image_family = var.source_image_family
  # source_image        = "test-ami-image"
  source_image        = "ubuntu-2204-jammy-v20240927"
  zone                = var.zone
  image_name          = var.image_name
  image_family        = "yeedu-ubuntu"
  ssh_username        = "yeedu"
  ssh_password        = "yeedu"
  machine_type        = "n1-standard-4"
  disk_size           = 50
  disk_type           = "pd-standard"
  network_project_id  = "modak-nabu"
  network             = "modak-nabu-spark-vpc"
  subnetwork          = "custom-subnet-modak-nabu"
  # on_host_maintenance = "TERMINATE"   
  use_internal_ip     = false
  # wrap_startup_script = true
  # startup_script_file = "scripts/setup.sh"
  metadata = {
    "enable-oslogin" = "FALSE"
  }

  image_labels = {
    poc       = "packer"
    resources = "yeedu"
  }
}



build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "file"{
    source = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "shell"{
    inline = [
      "sudo chmod +x /tmp/setup.sh",
      "sudo bash /tmp/setup.sh"
    ]
  }
}