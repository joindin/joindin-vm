class joindin::mailcatcher {
    package { 'gcc-c++':
        ensure   => 'installed'
    }
    package { 'ruby-devel':
        ensure   => 'installed'
    }
    package { 'sqlite-devel':
        ensure   => 'installed'
    }
    package { 'mailcatcher':
        ensure   => 'installed',
        provider => 'gem',
        require  => Package['ruby-devel', 'gcc-c++', 'sqlite-devel'],
    }
    file { "mailcatcher" :
        path   => "/etc/init.d/mailcatcher",
        source => "puppet:///modules/joindin/mailcatcher",
        owner  => "root",
        group  => "root",
    }
    service { 'mailcatcher':
        ensure => 'running',
        enable => true,
        require => [Package['mailcatcher'], File['mailcatcher'], File['mailcatcher-php.ini']]
    }
    file { "mailcatcher-php.ini" :
        path   => "/etc/php.d/mailcatcher.ini",
        source => "puppet:///modules/joindin/mailcatcher.ini",
        owner  => "root",
        group  => "root",
        require => [Package['php']]
    }
}
