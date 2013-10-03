class joindin::app (
	$dbname = 'joindin',
	$dbuser = 'joindin',
	$dbpass = 'password'
) {

    # Initialize database structure
    exec { 'init-db':
        creates => '/tmp/.patched',
        command => "/vagrant/joindin-api/scripts/patchdb.sh \
                    -t /vagrant/joindin-api -d $dbname -u $dbuser \
                    -p $dbpass -i && touch /tmp/.patched",
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
        creates => '/tmp/seed.sql',
        command => 'php /vagrant/joindin-api/tools/dbgen/generate.php > /tmp/seed.sql',
        require => [
	    Package['php'],
	    Exec['init-db'],
	]
    }

    # Seed database
    exec { 'seed-db':
        creates => '/tmp/.seeded',
        command => "mysql $dbname < /tmp/seed.sql && touch /tmp/.seeded",
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

    # Set some configuration for the VM
    exec { 'application-config-values':
        creates => '/tmp/.config_values_set', 
        command => "sh /vagrant/scripts/fixConfig.sh && touch /tmp/.config_values_set", 
        require => File['application-config'],
    }

    # Create directory for user-generated content
    file { 'upload-directory':
        ensure  => directory,
        path    => '/tmp/ctokens',
        mode    => '0644',
        owner   => 'apache',
        group   => 'apache',
        require => Service['apache'],
    }

}
