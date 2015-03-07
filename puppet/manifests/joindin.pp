
# Set default path for Exec calls
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

node default {
    include joindin
}

notify { 'urls':
    message => 'VM is ready. You can view the application on
        `http://web2.dev.joind.in/`
        `http://api.dev.joind.in/`
        `http://dev.joind.in/`
        ',
    require => Class['joindin'],
}
