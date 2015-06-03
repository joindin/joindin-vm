class joindin::node {

    include nodejs

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
