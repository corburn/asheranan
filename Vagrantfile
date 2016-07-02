# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
#Vagrant.require_version ">= 1.6.0"

# Create and configure the VM(s)
Vagrant.configure("2") do |config|

  # Assign a friendly name to this host VM
  config.vm.hostname = "docker-host"

  # Skip checking for an updated Vagrant box
  #config.vm.box_check_update = false

  # Always use Vagrant's default insecure key
  #config.ssh.insert_key = false

  # Spin up a "host box" for use with the Docker provider
  # and then provision it with Docker
  #config.vm.box = "slowe/ubuntu-trusty-x64"
  #config.vm.provision "docker"
  config.vm.provider "docker" do |d|
    d.image = "nginx"
  end

  # Disable synced folders (prevents an NFS error on "vagrant up")
  #config.vm.synced_folder ".", "/vagrant", disabled: true
end
