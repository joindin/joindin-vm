class joindin::web::phpmyadmin {

    # Install PHPMyAdmin on /phpmyadmin
    package { "phpmyadmin" :
        ensure  => present,
    }

    # Setup our own phpmyadmin configuration file
    file { "/etc/apache2/conf.d/phpmyadmin.conf" :
        source  => "puppet:///modules/joindin/phpmyadmin.conf",
        owner   => "root",
        group   => "root",
        require => Package["phpmyadmin"],
        notify  => Service["apache"],
    }

}
