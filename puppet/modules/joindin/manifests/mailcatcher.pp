class joindin::mailcatcher {
    package { 'gcc':
        ensure   => 'installed'
    }
    package { 'ruby-dev':
        ensure   => 'installed'
    }
    package { 'libsqlite3-dev':
        ensure   => 'installed'
    }
    package { 'mailcatcher':
        ensure   => 'installed',
        provider => 'gem',
        require  => Package['ruby-dev', 'gcc', 'libsqlite3-dev'],
    }
    file { "mailcatcher" :
        ensure => 'present',
        path   => "/etc/init.d/mailcatcher",
        source => "puppet:///modules/joindin/mailcatcher",
        owner  => "root",
        group  => "root",
        require  => Package['mailcatcher'],
    }
    file { "mailcatcher-php.ini" :
        ensure => 'present',
        path   => "/etc/php5/apache2/conf.d/30-mailcatcher.ini",
        source => "puppet:///modules/joindin/mailcatcher.ini",
        owner  => "root",
        group  => "root",
        require => [Package['php']]
    }
    service { 'mailcatcher':
        ensure => 'running',
        enable => true,
        require => [Package['mailcatcher'], File['mailcatcher'], File['mailcatcher-php.ini']]
    }

    exec { 'mailcatcher-run-on-boot':
        onlyif => "test ! -f /etc/rc2.d/S18mailcatcher",
        command => "update-rc.d mailcatcher defaults",
        require => Service['mailcatcher'],
    }

    # Remove exim4 to ensure that the vm will never send an email by mistake
    service { 'exim4':
        ensure => 'stopped',
        enable => false,
    }
}
