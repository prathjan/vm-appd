

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "external" "appd" {
  program = ["bash", "./scripts/getappd.sh"]
  query = {
    appname = "${var.appname}" 
    accesskey = "${var.accesskey}" 
    jver = "${var.javaver}" 
  }
#    clsecrt = "${var.clsecrt}" 
#    zerover = "${var.zerover}" 
#    infraver = "${var.infraver}" 
#    machinever = "${var.machinever}" 
#    ibmver = "${var.ibmver}" 
#    javaver = "${var.javaver}" 
}


resource "random_string" "folder_name_prefix" {
  length    = 10
  min_lower = 10
  special   = false
  lower     = true

}


resource "vsphere_folder" "vm_folder" {
  path          =  "${var.vm_folder}-${random_string.folder_name_prefix.id}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm_deploy" {
  count            = var.vm_count
  name             = "${var.vm_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.vm_folder.path
  firmware = "bios"

  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vm_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {}
    }
  }

}


resource "null_resource" "vm_node_init" {
  count = "${var.vm_count}"

  provisioner "file" {
    source = "scripts/appd.sh"
    destination = "/tmp/appd.sh"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "file" {
    source = "scripts/tom.sh"
    destination = "/tmp/tom.sh"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "cisco"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "file" {
    source = "scripts/tomsvc"
    destination = "/etc/systemd/system/apache-tomcat-7.service"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "remote-exec" {
    inline = [
	"chmod +x /tmp/appd.sh",
        "/tmp/appd.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "remote-exec" {
    inline = [
        "${data.external.appd.result["download"]};${data.external.appd.result["install"]}",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "remote-exec" {
    inline = [
	"chmod +x /tmp/tom.sh",
        "/tmp/tom.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "cisco"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "file" {
    source = "scripts/tomuser.xml"
    destination = "/usr/local/apache/apache-tomcat-7/conf/tomcat-users.xml"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "file" {
    source = "scripts/mgrctx.xml"
    destination = "/usr/local/apache/apache-tomcat-7/webapps/manager/META-INF/context.xml"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "file" {
    source = "scripts/hostmgrctx.xml"
    destination = "/usr/local/apache/apache-tomcat-7/webapps/host-manager/META-INF/context.xml"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "cisco"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }


#  provisioner "remote-exec" {
#    inline = [
#        "${data.external.appd.result["install"]}",
#    ]
#    connection {
#      type = "ssh"
#      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
#      user = "root"
#      password = "${var.root_password}"
#      port = "22"
#      agent = false
#    }
#  }
}

output "vm_deploy" {
  value = [vsphere_virtual_machine.vm_deploy.*.name, vsphere_virtual_machine.vm_deploy.*.default_ip_address]
}

output "download" {
  value = data.external.appd.result["download"]
}
output "install" {
  value = data.external.appd.result["install"]
}
