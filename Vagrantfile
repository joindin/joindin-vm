# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # We define one box (joindin), but
  config.vm.define :joindin do |ji_config|

    # The original base box used to create joindin/development was 'puphpet/debian75-x64'
    ji_config.vm.box = 'joindin/development'

    ji_config.vm.host_name = "dev.joind.in"
    if Vagrant.has_plugin?('vagrant-hostsupdater')
      ji_config.hostsupdater.aliases = ["legacy.dev.joind.in", "api.dev.joind.in"]
    end

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
