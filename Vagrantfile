# -*- mode: ruby -*-
# vi: set ft=ruby :

#############
# VARIABLES #
############# 

box_image = "generic/rocky9"
project_id = "3"

###################
# KEY GENERATION  #
# #################

# provide utilities for creating, copying, moving, and deleting files and directories
require 'fileutils'

ssh_key_path = File.join(__dir__, "vagrant", ".ssh")
ssh_key_private = File.join(ssh_key_path, "ansible_lab_003")
ssh_key_public = "#{ssh_key_private}.pub"

FileUtils.mkdir_p(ssh_key_path)
unless File.directory?(ssh_key_path)
  system(
    "ssh-keygen",
    "-t", "ed25519",
    "-f", ssh_key_private,
    "-N", "",
    "-C", "ansible_lab_003"
    )
end 

Vagrant.configure("2") do |config|
    config.vm.box = box_image
    config.vm.synced_folder ".", "/vagrant", disabled: false
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
    end

CONTROLLER = { name: "controller-301", ip: "192.168.56.10", memory: 2048, cpus: 2 }
 
  config.vm.define CONTROLLER[:name] do |controller|
        controller.vm.hostname = CONTROLLER[:name]
        controller.vm.network "private_network", ip: CONTROLLER[:ip] 
        controller.vm.provider "virtualbox" do |vb|
            vb.memory = CONTROLLER[:memory]
            vb.cpus = CONTROLLER[:cpus]
            vb.name = CONTROLLER[:name]
        end
        controller.vm.provision "shell", path: "scripts/bootstrap-ansible-controller.sh", privileged: false
        controller.vm.provision "shell", path: "scripts/deploy-private-key.sh", privileged: false
    end

MANAGED_NODES = [
    { name: "managed-301", ip: "192.168.56.11", memory: 1024, cpus: 1 }
    ]

  MANAGED_NODES.each do |managed|
        config.vm.define managed[:name], autostart: true do |node|
            node.vm.hostname = managed[:name]
            node.vm.network "private_network", ip: managed[:ip]
            node.vm.provider "virtualbox" do |vb|
                vb.memory = managed[:memory]
                vb.cpus = managed[:cpus]
                vb.name = managed[:name]
            end
            node.vm.provision "shell", path: "scripts/deploy-public-key.sh", privileged: false
        end
    end
end
