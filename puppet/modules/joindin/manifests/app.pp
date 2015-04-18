class joindin::app (
	$dbname = 'joindin',
	$dbuser = 'joindin',
	$dbpass = 'password'
) {

    # Initialize database structure
    exec { 'init-db':
        creates => '/home/vagrant/.patched',
        command => "/vagrant/joindin-api/scripts/patchdb.sh \
                    -t /vagrant/joindin-api -d $dbname -u $dbuser \
                    -p $dbpass -i && touch /home/vagrant/.patched",
        require => Exec['create-db'],
    }

    # Patch database structure
    exec { 'patch-db':
        command => "/vagrant/joindin-api/scripts/patchdb.sh \
                    -t /vagrant/joindin-api -d $dbname -u $dbuser \
                    -p $dbpass",
        require => [
            Exec['create-db'],
            Exec['init-db'],
        ],
    }

    # Generate seed data
    exec { 'seed-data':
        creates => '/home/vagrant/seed.sql',
        command => 'php /vagrant/joindin-api/tools/dbgen/generate.php > /home/vagrant/seed.sql',
        require => [
	    Package['php'],
	    Exec['init-db'],
	]
    }

    # Seed database
    exec { 'seed-db':
        creates => '/home/vagrant/.seeded',
        command => "mysql $dbname < /tmp/seed.sql && touch /home/vagrant/.seeded",
        require => [
                       Exec['init-db'],
                       Exec['seed-data'],
                   ],
    }

    # Set database config for application
    file { 'database-config':
        path   => '/vagrant/joind.in/src/system/application/config/database.php',
        content => template('joindin/database.php.erb'),
		replace => false, 
    }

    # Set database config for application
    file { 'api-database-config':
        path    => '/vagrant/joindin-api/src/database.php',
        content => template('joindin/database.php.erb'),
    }

    # Set core config for application
    file { 'application-config':
        path    => '/vagrant/joind.in/src/system/application/config/config.php',
        source  => '/vagrant/joind.in/src/system/application/config/config.php.dist',
        replace => no,
    }

    # Create directory for user-generated content
    file { 'upload-directory':
        ensure  => directory,
        path    => '/tmp/ctokens',
        mode    => '0644',
        owner   => 'www-data',
        group   => 'www-data',
        require => Service['apache'],
    }

    # Configure the web2
    file { 'web2-config':
        ensure  => present,
        owner   => 'vagrant',
        path    => '/vagrant/joindin-web2/config/config.php',
        source  => "/vagrant/joindin-web2/config/config.php.dist",
        replace => no,
    }

    # Set core config for api
    file { 'api-config':
        path    => '/vagrant/joindin-api/src/config.php',
        source  => '/vagrant/joindin-api/src/config.php.dist',
        replace => no,
    }

    # Set some configuration for the VM
    exec { 'application-config-values':
        creates => '/home/vagrant/.config_values_set',
        command => "sh /vagrant/scripts/fixConfig.sh && touch /home/vagrant/.config_values_set",
        require => [
            File['application-config'],
            File['web2-config'],
            File['api-config'],
        ]
    }

}
