# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # We define one box (joindin), but
  config.vm.define :joindin do |ji_config|

    ji_config.vm.box = 'centos-6x-64-puppet_chef'
    ji_config.vm.box_url = 'http://packages.vstone.eu/vagrant-boxes/centos/6.x/centos-6.x-64bit-puppet.3.x-chef.0.10.x-vbox.4.2.12-3.box'

    ji_config.vm.host_name = "joind.in"

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    ji_config.vm.forward_port 80, 8080


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
        '--verbose',
        # '--debug',
        # '--graph',
        # '--graphdir=/vagrant/puppet/graphs'
        "--hiera_config /vagrant/puppet/hiera.yaml"
      ]
    end
  end
  config.vm.network :hostonly, "192.168.33.15"
end
