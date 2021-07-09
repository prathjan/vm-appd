// The zero agent version
variable "zerover" {
  type = string
}
// The client secret
variable "clsecrt" {
  type = string
}
// The infra version 
variable "infraver" {
  type = string
}
// The machinever 
variable "machinever" {
  type = string
}
// The ibmver 
variable "ibmver" {
  type = string
}
// The javaver 
variable "javaver" {
  type = string
}

// The application name for appd
variable "appname" {
  type = string
}
// The accesskey for appd
variable "accesskey" {
  type = string
}
// The vsphere ip address
variable "vsphere_server" {
  type = string
}

// The vsphere user
variable "vsphere_user" {
  type = string
}

// The vsphere password
variable "vsphere_password" {
  type = string
}

// The datacenter the resources will be created in.
variable "datacenter" {
  type = string
}


// The resource pool the virtual machines will be placed in.
variable "resource_pool" {
  type = string
}

// The name of the datastore to use.
variable "datastore_name" {
  type = string
}

// The name of the network to use.
variable "network_name" {
  type = string
}

// The name of the template to use when cloning.
variable "template_name" {
  type = string
}


// The virtual machine cpu
variable "vm_cpu" {
  type = string
}

variable "vm_memory" {
  type = string
}

variable "vm_prefix" {
  type = string
}

variable "vm_folder" {
  type = string
}

variable "vm_count" {
  type = number
  validation {
    condition     = can(regex("^(1|2|3|4)$", var.vm_count))
    error_message = "VM count must be 1 to 4."
  }
}

// The name prefix of the virtual machines to create.
variable "vm_domain" {
  type = string
}
variable "root_password" {
  type = string
}
