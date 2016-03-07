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

    exec { 'updatephp':
        path        => '/bin:/usr/bin:/sbin:/usr/sbin/',
        command     => 'apt-get install php5 php5-curl -q -y --ignore-hold', #php5-xdebug
        require     => Exec['update-apt'],
    }

    # Install PHP modules
    php::module { 'mysql':
        require => Exec['update-apt'],
    }

    # Latest dotdeb is missing Xdebug. Will bring it back when they add it
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
            'set PHP/always_populate_raw_post_data -1',
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
            'set PHP/always_populate_raw_post_data -1',
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


    # Add a row to the hosts file for the virtual hosts
    host { "api.dev.joind.in":
        ip => "127.0.0.1",
    }
    host { "dev.joind.in":
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

    file { "xdebug.ini" :
        ensure => 'present',
        path   => "/etc/php5/apache2/conf.d/30-xdebug.ini",
        source => "puppet:///modules/joindin/xdebug.ini",
        owner  => "root",
        group  => "root",
        require => [Package['php']],
        notify  => Service['apache']
    }

    # symlink for icons
    file { "/vagrant/joindin-web2/web/inc":
      ensure => 'link',
      target => "/vagrant/joind.in/src/inc",
    }

    # set the Apache user to vagrant so that file uploads work
    exec { "apache-user-change" :
        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Change the Apache group to be vagrant
    exec { "apache-group-change" :
        command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
        require => Package["apache"],
        notify  => Service["apache"],
    }
    
    # change the Apache lock file permissions so that the vagrant owner can start Apache
    file { 'apache-lockfile-permissions':
        path => '/var/lock/apache2',
        recurse => false,
        owner => 'vagrant',
        group => 'www-data',
        mode => 0755,
    }
}
