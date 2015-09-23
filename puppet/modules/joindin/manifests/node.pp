class joindin::node {

    class { 'nodejs':
      make_install => false
    }

    package { 'grunt-cli':
      provider => 'npm',
      require  => Class['nodejs']
    }

    # exec { 'install-grunt':
    #     command => 'npm install -g grunt-cli',
    #     require => Class['nodejs']
    #     # onlyif => "test ! -f /usr/local/bin/grunt"
    # }
}
