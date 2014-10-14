class joindin::web ($phpmyadmin = false, $host = 'dev.joind.in', $port = 80) {
    include apache
	include redis

    # include phpmyadmin if needed
    if $phpmyadmin == true {
        include joindin::web::phpmyadmin
    }

    # Configure apache virtual host
    apache::vhost { $host :
        docroot  => '/vagrant/',
        template => 'joindin/vhost.conf.erb',
        port     => $port,
        require  => Package["apache"],
    }

    # Install PHP modules
    php::module { 'mysql':
        require => Exec['update-apt'],
    }
    php::module { ["xdebug"] :
        # require => File["EpelRepo"],            # xdebug is in the epel repo
        require => Exec['update-apt'],
    }

    # API requires curl
    php::module { 'curl':
      require => Package['php'],
    }

    # Set development values to our php.ini
    augeas { 'set-php-ini-values':
        context => '/files/etc/php5/apache2/php.ini',
        changes => [
            'set PHP/error_reporting "E_ALL | E_STRICT"',
            'set PHP/display_errors On',
            'set PHP/display_startup_errors On',
            'set PHP/html_errors On',
            'set Date/date.timezone Europe/London',
        ],
        require => Package['php'],
        notify  => Service['apache'],
    }

    augeas { 'set-cli-php-ini-values':
        context => '/files/etc/php5/cli/php.ini',
        changes => [
            'set PHP/error_reporting "E_ALL | E_STRICT"',
            'set PHP/display_errors On',
            'set PHP/display_startup_errors On',
            'set PHP/html_errors On',
            'set Date/date.timezone Europe/London',
        ],
        require => Package['php'],
        notify  => Service['apache'],
    }


    exec { 'enable-php5':
        onlyif => "test ! -f /etc/apache2/mods-enabled/php5.load",
        command => "sudo a2enmod php5 && sudo a2enmod rewrite",
        require => Augeas['set-php-ini-values'],
        notify  => Service['apache'],
    }


    # Add a row to the hosts file for the API calls
    host { "api.dev.joind.in":
        ip => "127.0.0.1",
    }

    # ensure that the /tmp/ctokens folder is created
    file { 'joindin-ctokens' :
        ensure => 'present',
        path   => "/etc/init.d/joindin-ctokens",
        source => "puppet:///modules/joindin/joindin-ctokens",
        owner  => "root",
        group  => "root",
    }
    exec { 'joindin-ctokens-run-on-boot':
        onlyif => "test ! -f /etc/rcS.d/S19joindin-ctokens",
        command => "update-rc.d joindin-ctokens start 19 S",
        require => File['joindin-ctokens'],
    }
}
