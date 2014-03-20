class joindin::sql ($dbuser = 'joindin', $dbpass = 'password', $dbname = 'joindin') {

    include mysql

    # Create and grant privileges to joindin database
    exec { 'create-db':
        unless  => "mysql -u${dbuser} -p${dbpass} ${dbname}",
        command => "mysql -e \"create database ${dbname}; \
                    grant all on ${dbname}.* \
                    to ${dbuser}@'%' identified by '${dbpass}';\"",
        require => Service['mysql'],
    }

}
