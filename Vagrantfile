# -*- mode: ruby -*-
# vi: set ft=ruby :

system('[ $(vagrant plugin list | grep -c vagrant-libvirt) = "0" ] && echo \'You need to install vagrant-libvirt plugin to continue\' && exit 1')

# If you are using ubuntu as baremetal OS, you probably need to indicate where libvirt is installed using the following :
# apt install libvirt-dev
# CONFIGURE_ARGS=\'with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib\' vagrant plugin install vagrant-libvirt 

Vagrant.configure("2") do |epc|

  epc.vm.box = "generic/ubuntu1804"

  epc.vm.network  "private_network", ip: "192.168.25.60"

  epc.vm.provider :libvirt do |domain|
     domain.memory = 2048 
     domain.cpus = 2
     domain.nested = true
     domain.autostart = true
  end

  # ansible is a dependency to enable provisioning
  epc.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    sed -i s,"us.archive","archive",g /etc/apt/sources.list
    apt-get update
    apt-get install -yq ansible
  SHELL

  # ship EPC building and config files to the VM
  epc.vm.provision "file", source: "Dockerfile", destination: "$HOME/epc/"
  epc.vm.provision "file", source: "docker-compose-standalone.yml", destination: "$HOME/epc/docker-compose.yml"
  epc.vm.provision "file", source: "config-standalone/", destination: "$HOME/epc/"
  epc.vm.provision "file", source: "provisioning/", destination: "$HOME/epc/"

  # provisioning and running EPC services
  epc.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook-standalone.yml"
  end

end