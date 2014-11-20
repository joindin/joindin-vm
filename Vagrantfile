# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # We define one box (joindin), but
  config.vm.define :joindin do |ji_config|

    ji_config.vm.box = 'joindin/development'

    ji_config.vm.host_name = "dev.joind.in"
    ji_config.hostsupdater.aliases = ["web2.dev.joind.in", "api.dev.joind.in"]

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    ji_config.vm.network :private_network, ip: "10.223.175.44"

    # Share an additional folder to the guest VM. The first argument is
    # an identifier, the second is the path on the guest to mount the
    # folder, and the third is the path on the host to the actual folder.
    # config.vm.share_folder "v-data", "/vagrant_data", "../data"

    # Use :gui for showing a display for easy debugging of vagrant
    #ji_config.vm.boot_mode = :gui

    ji_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file = "joindin.pp"
      puppet.options = [
        # '--verbose',
        # '--debug',
        # '--graph',
        # '--graphdir=/vagrant/puppet/graphs'
        "--hiera_config /vagrant/puppet/hiera.yaml"
      ]
    end
  end
end
