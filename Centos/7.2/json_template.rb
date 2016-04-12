require 'multi_json'
MultiJson.use :yajl

{
  "builders": [
    {
      "boot_command": [
        "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "10s",
      "disk_size": "{{user `disk_size`}}",
      "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
      "guest_os_type": "{{user `guest_os_type`}}",
      "headless": true,
      "http_directory": "http",
      "iso_checksum": "{{user `iso_checksum`}}",
      "iso_checksum_type": "{{user `iso_checksum_type`}}",
      "iso_url": "{{user `iso_url`}}",
      "shutdown_command": "echo '/sbin/halt -h -p' > /tmp/shutdown.sh; echo 'vagrant'|sudo -S sh '/tmp/shutdown.sh'",
      "ssh_password": "{{user `ssh_password`}}",
      "ssh_port": 22,
      "ssh_username": "{{user `ssh_username`}}",
      "ssh_wait_timeout": "10000s",
      "type": "virtualbox-iso",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "{{user `mem_size`}}"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "{{user `numvcpus`}}"
        ]
      ],
      "virtualbox_version_file": ".vbox_version"
    },
    {
      "boot_command": [
        "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "10s",
      "disk_size": "{{user `disk_size`}}",
      "guest_os_type": "redhat",
      "headless": true,
      "http_directory": "http",
      "iso_checksum": "{{user `iso_checksum`}}",
      "iso_checksum_type": "{{user `iso_checksum_type`}}",
      "iso_url": "{{user `iso_url`}}",
      "shutdown_command": "echo '/sbin/halt -h -p' > /tmp/shutdown.sh; echo 'vagrant'|sudo -S sh '/tmp/shutdown.sh'",
      "ssh_password": "{{user `ssh_password`}}",
      "ssh_port": 22,
      "ssh_username": "{{user `ssh_username`}}",
      "ssh_wait_timeout": "10000s",
      "tools_upload_flavor": "linux",
      "type": "vmware-iso",
      "vmx_data": {
        "cpuid.coresPerSocket": "1",
        "memsize": "{{user `mem_size`}}",
        "numvcpus": "{{user `numvcpus`}}"
      }
    },
    {
      "accelerator": "kvm",
      "boot_command": [
        "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "5s",
      "disk_interface": "virtio",
      "disk_size": 5000,
      "format": "qcow2",
      "headless": true,
      "http_directory": "httpdir",
      "http_port_max": 10089,
      "http_port_min": 10082,
      "iso_checksum": "{{user `iso_checksum`}}",
      "iso_checksum_type": "{{user `iso_checksum_type`}}",
      "iso_url": "{{user `iso_url`}}",
      "net_device": "virtio-net",
      "shutdown_command": "shutdown -P now",
      "ssh_host_port_max": 2229,
      "ssh_host_port_min": 2222,
      "ssh_password": "{{user `ssh_password`}}",
      "ssh_port": 22,
      "ssh_username": "{{user `ssh_username`}}",
      "ssh_wait_timeout": "10000s",
      "type": "qemu",
      "vm_name": "{{user `vm_name`}}"
    }
  ],
  "post-processors": [
    [
      {
        "keep_input_artifact": false,
        "override": {
          "qemu": {
            "output": "{{user `vm_name`}}-qemu.box"
          },
          "virtualbox": {
            "output": "{{user `vm_name`}}-virtualbox.box"
          },
          "vmware": {
            "output": "{{user `vm_name`}}-vmware.box"
          }
        },
        "type": "vagrant"
      },
      {
        "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
        "artifact_type": "vagrant.box",
        "metadata": {
          "provider": "vmware_desktop",
          "version": "{{user `version`}}"
        },
        "only": [
          "vmware-iso"
        ],
        "type": "atlas"
      },
      {
        "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
        "artifact_type": "vagrant.box",
        "metadata": {
          "provider": "qemu",
          "version": "{{user `version`}}"
        },
        "only": [
          "qemu"
        ],
        "type": "atlas"
      },
      {
        "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
        "artifact_type": "vagrant.box",
        "metadata": {
          "provider": "virtualbox",
          "version": "{{user `version`}}"
        },
        "only": [
          "virtualbox-iso"
        ],
        "type": "atlas"
      }
    ]
  ],
  "provisioners": [
    {
      "execute_command": "echo 'vagrant'|sudo -S sh '{{.Path}}'",
      "override": {
        "PROVISOR" : {
          "scripts": [
            "scripts/base.sh",
            "scripts/vagrant.sh",
            "scripts/virtualbox.sh",
            "scripts/cleanup.sh"
          ]
        },
        "virtualbox-iso": {
          "scripts": [
            "scripts/base.sh",
            "scripts/vagrant.sh",
            "scripts/virtualbox.sh",
            "scripts/cleanup.sh"
          ]
        },
        "vmware-iso": {
          "scripts": [
            "scripts/base.sh",
            "scripts/vagrant.sh",
            "scripts/vmware.sh",
            "scripts/cleanup.sh"
          ]
        }
      },
      "type": "shell"
    }
  ],
  "variables": {
    "atlas_name": "#{ENV['ATLAS_NAME']}",
    "atlas_username": "#{ENV['ATLAS_USERNAME']}",
    "disk_size": "#{ENV['DISK_SIZE']}",
    "guest_os_type": "#{ENV['GUEST_OS_TYPE']}",
    "iso_checksum": "#{ENV['ISO_CHECKSUM']}",
    "iso_checksum_type": "#{ENV['ISO_CHECKSUM_TYPE']}",
    "iso_url": "#{ENV['ISO_URL']}",
    "mem_size": "#{ENV['MEM_SIZE']}",
    "numvcpus": "#{ENV['NUMVCPUS']}",
    "ssh_password": "#{ENV['SSH_PASSWORD']}",
    "ssh_username": "#{ENV['SSH_USERNAME']}",
    "version": "#{ENV['VMVERSION']}",
    "vm_name": "#{ENV['VM_NAME']}"
  }
}
