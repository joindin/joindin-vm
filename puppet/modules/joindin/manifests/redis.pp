class joindin::redis {
    package { 'redis-server':
        ensure => 'installed',
        require => Exec['update-apt'],
    }
    service { 'redis-server':
        ensure => 'running',
        enable => true,
        require  => Package["redis-server"],
    }
}
