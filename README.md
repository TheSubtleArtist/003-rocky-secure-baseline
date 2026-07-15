# Project 003 Secure Rocky Baseline

## Purpose

This project uses Ansible roles to apply a basic security baseline to the Rocky Linux 9 operating systems.

## Project Objectives

- Security baseline design
- role-based hardening
- validation as indpendent expected state
- evidence capture
- safe incremental changes

## Project Scope

- SSH hardening basics
- login banner
- password/authentication policy awareness
- basic firewall service validation
- audit/logging package/service validation
- explicit `expected_` validation variables

## Repository Structure

003-rocky-ansible-roles/
├── ansible/
│   ├── roles/
│   |   ├── common/
│   |   │   ├── defaults/
│   |   │   │   └── main.yml
│   |   │   └── tasks/
│   |   │       └── main.yml
│   |   ├── controller/
│   |   │   ├── defaults/
│   |   │   │   └── main.yml
│   |   │   └── tasks/
│   |   │       └── main.yml
│   |   └── managed_node/
│   |       ├── defaults/
│   |       │   └── main.yml
│   |       └── tasks/
│   |           └── main.yml
│   ├── tests/
│   |   ├── test-common-role.yml
│   |   ├── test-controller-role.yml
│   |   └── test-managed-node-role.yml
│   ├── inventory-003.ini
│   ├── site.yml
│   ├── validate.yml
├── evidence/
│   ├── test-common-role-output.txt
│   ├── test-controller-role-output.txt
│   └── vtest-managed-node-role-output.txt
├── scripts/
│   ├── bootstrap-ansible-controller.sh
│   ├── deploy-private-key.sh
│   ├── deploy-public-key.sh
│   ├── play-site-yml.sh
│   ├── test-common-role.sh
│   ├── test-controller-role.sh
│   ├── test-managed-node.sh
│   ├── test-site.sh
│   └── validation.sh
├── vagrant/.ssh
│   ├── ansible_lab
│   └── ansible_lab.pub
├── .gitignore
├── ansible.cfg
├── README.md
└── Vagrantfile

## Build and Validation Workflow

### 1. Build and Validate `Vagrantfile`

The Vagrantfile defines the virtual machines, hostnames, private network addresses, resource allocations, synced project directory, and provisioning scripts used to bootstrap the lab.  

#### Nodes

controller-301 = Project 003 controller node 01; Runs Ansible and manages the lab.
managed-301    = Project 003 managed node 01; Target system configured by Ansible

This keeps with the pattern established in the previous project and, as with the previous project, ensures scalability.  

#### Network

controller-301 = 192.168.57.10
managed-301    = 192.168.57.11

For this project, only a private host-only network is created to provide VM-to-VM communication. Outbound communications are provided through the host, using the VirtualBox NAT interface.

```text
VM -> VirtualBox NAT -> host machine -> internet
```

#### Resource Allocation

controller-301 = 2 CPU / 2048 MB RAM
managed-301    = 1 CPU / 1024 MB RAM

For the purposes of this project, there is no need to overly allocate resources. The controller is assigned additional resources to run Ansible tooling.

#### SSH Key Generation

Vagrant creates or manages SSH access so the host machine can connect to each VM with commands such as `vagrant ssh controller-301`. That is useful for operator access, but it is not the same as creating a clear Ansible management trust path between the controller VM and the managed node VM.  

The key files are generated before VM provisioning so the provisioning scripts can use them immediately. The private key deployment script copies the private key to the controller. The public key deployment script appends the public key to the managed node’s authorized_keys file.

Generating the project-local key has benefits:  

1. The Ansible controller has a known private key for managing lab nodes.
2. Managed nodes receive a matching public key during provisioning.
3. The Ansible inventory can reference a predictable key path.
4. The SSH trust model is visible in the repository logic.
5. The lab can be rebuilt without manually copying keys between machines.
6. Existing keys are not overwritten every time Vagrant runs.


The Vagrantfile uses Ruby file utilities to create the key path and generate the key only if it does not already exist.  

`FileUtils` provides helper methods for common file and directory operations, such as creating directories, copying files, moving files, and deleting files. In this project, it is used to create the local SSH key directory if needed.

`File.join()` builds a file path from separate path components. This is better than manually writing a path string because Ruby joins the pieces using the correct path separator for the operating system.

`__dir__` refers to the directory where this Vagrantfile is located. This keeps the key path tied to the repository root instead of depending on whatever directory the user happens to be in when they run Vagrant.

`FileUtils.mkdir_p()` creates the directory path if it does not already exist. It behaves like the Linux command: `mkdir -p`

`unless File.exist?()` means “run the following block only if this file does not already exist.” The Vagrantfile creates the SSH key pair the first time the lab is built, but it does not overwrite the key on later runs. That matters because replacing the private key without updating the matching public key on managed nodes would break SSH access from the controller to the managed node.  

This creates an Ed25519 SSH key pair. The `-f` option sets the private key file path. The `-N ""` option creates the key without a passphrase so Ansible can use it non-interactively inside the lab. The `-C` option adds a comment identifying the key as part of Project 003.

#### Key Deployment

The private key is deployed to the controller.
The public key is deployed to managed nodes.
The controller uses the private key to connect to managed nodes over SSH.

`deploy-private-key.sh` places the lab private key on the controller
`deploy-public-key.sh` places the lab public key on managed nodes

#### Vagrantfile Validation

`vagrant validate` confirms that the syntax in `Vagrantfile` isvalid and can be parsed by Vagrant.  It does not prove that the VMs can boot, that provisioning scripts succeed, that SSH keys are deployed correctly, or that Ansible can connect to managed nodes.  

