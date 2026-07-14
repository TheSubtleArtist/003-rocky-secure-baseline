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

  controller = [{name: "controller-301", ip: "192.168.56.10", memory: 2048, cpus: 2}]
  config.vm.define controller[:name] do |controller|
        controller.vm.hostname = controller[:name]
        controller.vm.network "private_network", ip: controller[:ip] 
        controller.vm.provider "virtualbox" do |vb|
            vb.memory = controller[:memory]
            vb.cpus = controller[:cpus]
            vb.name = controller[:name]
        end
        controller.vm.provision "shell", path: "scripts/bootstrap-ansible-controller.sh", privileged: false
        controller.vm.provision "shell", path: "scripts/deploy-private-key.sh", privileged: false
  end

  managed_nodes = [{name: "managed-301", ip: "192.168.56.11", memory: 1024, cpus: 1}]
  managed_nodes.each do |node|
        config.vm.define node[:name], autostart: true do |node|
            node.vm.hostname = node[:name]
            node.vm.network "private_network", ip: node[:ip]
            node.vm.provider "virtualbox" do |vb|
                vb.memory = node[:memory]
                vb.cpus = node[:cpus]
                vb.name = node[:name]
            end
            node.vm.provision "shell", path: "scripts/deploy-public-key.sh", privileged: false
        end
  end
end
