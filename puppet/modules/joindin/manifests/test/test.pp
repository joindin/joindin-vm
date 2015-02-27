class joindin::test::test {

    # install wireshark for easier debugging
    package { 'wireshark':
          ensure  => latest,
          require  => Exec['update-apt'],
    }

    # Install ant to build test suite
    package { 'ant':
      #require => Notify['running'],
    }

    # Install required PEAR modules for test suite
    package { 'php-pear':
      require => Package['php'],
    }

    # Install test-suite tools
    file { 'phpunit':
        path    => '/usr/local/bin/phpunit',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phpunit",
        before  => Notify['test'],
        require => [Package['php']],
    }

    file { 'phploc':
        path    => '/usr/local/bin/phploc',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phploc",
        before  => Notify['test'],
        require => Package['php'],
    }

    file { 'phpcpd':
        path    => '/usr/local/bin/phpcpd',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phpcpd",
        before  => Notify['test'],
        require => Package['php'],
    }

    file { 'pdepend':
        path    => '/usr/local/bin/pdepend',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/pdepend",
        before  => Notify['test'],
        require => [Package['php']],
    }

    file { 'phpmd':
        path    => '/usr/local/bin/phpmd',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phpmd",
        before  => Notify['test'],
        require => [File['pdepend'], Package['php']],
    }

    file { 'phing.phar':
        path    => '/usr/local/bin/phing.phar',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phing.phar",
        before  => Notify['test'],
        require => Package['php'],
    }
    file { 'phing':
        ensure => 'link',
        path => '/usr/local/bin/phing',
        target => '/usr/local/bin/phing.phar',
        require => Package['php'],
    }


    package { 'graphviz': }

    file { 'phpdoc':
        path    => '/usr/local/bin/phpdoc',
        mode    => '0755',
        source => "puppet:///modules/joindin/tests/phpdoc",
        before  => Notify['test'],
        require => [Package['graphviz'], Package['php']],
    }

    exec { 'phpcs':
      creates => '/usr/bin/phpcs',
      command => 'pear install PHP_CodeSniffer',
      require => Package['php-pear'],
      before  => Notify['test'],
    }

    # Announce test-suite
    notify { 'test':
      message => 'Test-suite ready - run in VM with 
          `cd /vagrant/joind.in && phing`
          `cd /vagrant/joindin-api && phing`
          `cd /vagrant/joindin-web2 && phing`
      ',
    }
}
