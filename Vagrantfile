# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # We define one box (joindin), but
  config.vm.define :joindin do |ji_config|

    ji_config.vm.box = 'joindin/development'

    ji_config.vm.host_name = "joind.in"

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    ji_config.vm.forward_port 80, 8080
    ji_config.vm.forward_port 1080, 8081
    ji_config.vm.forward_port 3306, 3307


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
