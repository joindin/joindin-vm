
# Set default path for Exec calls
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}

node default {
    include joindin
}

notify { 'urls':
    message => 'VM is ready. You can view the application on
        `http://dev.joind.in/`
        `http://api.dev.joind.in/`
        `http://legacy.dev.joind.in/`
        ',
    require => Class['joindin'],
}
