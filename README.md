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

002-rocky-ansible-roles/
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
