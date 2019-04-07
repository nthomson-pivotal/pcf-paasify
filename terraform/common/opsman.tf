locals {
  opsman_password = "${random_string.opsman_password.result}"
}

resource "random_string" "opsman_password" {
  length  = 8
  special = false
}

data "template_file" "az_configuration" {
  template = "${chomp(file("${path.module}/templates/az.json"))}"

  vars {
    az_string = "${join(",", formatlist("{\"name\":\"%s\"}", var.azs))}"
  }
}

data "template_file" "network_assignment_configuration" {
  template = "${chomp(file("${path.module}/templates/network_assignment.json"))}"

  vars {
    az = "${var.azs[0]}"
  }
}

resource "null_resource" "setup_opsman" {

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "file" {
    content     = "${var.ssl_cert}"
    destination = "/tmp/tempest.crt"
  }

  provisioner "file" {
    content     = "${var.ssl_private_key}"
    destination = "/tmp/tempest.key"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/opsman/"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/provision_opsman.sh && /tmp/provision_opsman.sh ${var.pivnet_token} ${var.opsman_host} ${local.opsman_password}"]
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup_opsman.sh ${var.dependency_blocker}"

    environment {
      PIVNET_TOKEN         = "${var.pivnet_token}"
      OM_DOMAIN            = "${var.opsman_host}"
      OM_USERNAME          = "${var.opsman_user}"
      OM_PASSWORD          = "${local.opsman_password}"
      OM_IAAS_CONFIG       = "${var.opsman_iaas_configuration}"
      OM_AZ_CONFIG         = "${var.opsman_az_configuration == "" ? data.template_file.az_configuration.rendered : var.opsman_az_configuration}"
      OM_NETWORK_CONFIG    = "${var.opsman_network_configuration}"
      OM_NET_ASSIGN_CONFIG = "${data.template_file.network_assignment_configuration.rendered}"
      IAAS                 = "${var.iaas}"
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/post_install_opsman.sh && /tmp/post_install_opsman.sh ${var.bosh_director_ip}"]
  }

  connection {
    host        = "${var.opsman_host}"
    user        = "ubuntu"
    private_key = "${var.opsman_ssh_key}"
  }
}


resource "null_resource" "cleanup_opsman" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/destroy_opsman.sh ${var.dependency_blocker}"

    when = "destroy"

    environment {
      OM_ID       = "${var.opsman_id}"
      OM_IP       = "${var.opsman_ip}"
      OM_DOMAIN   = "${var.opsman_host}"
      OM_USERNAME = "${var.opsman_user}"
      OM_PASSWORD = "${local.opsman_password}"
      APPS_DOMAIN = "${var.apps_domain}"
      SYS_DOMAIN  = "${var.apps_domain}"
    }
  }

  depends_on = ["null_resource.setup_opsman"]
}