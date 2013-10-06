class joindin::web ($phpmyadmin = true, $host = 'dev.joind.in', $port = 80) {
    include apache
	include mongodb

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
    php::module { 'mysql': }
    php::module { ["pecl-xdebug", "pecl-mongo"] :
        require => File["EpelRepo"],            # xdebug is in the epel repo
    }

    # Set development values to our php.ini
    augeas { 'set-php-ini-values':
        context => '/files/etc/php.ini',
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

    # Add a row to the hosts file for the API calls
    host { "api.dev.joind.in":
        ip => "127.0.0.1",
    }

}
