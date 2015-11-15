class joindin::elastic {
    class { 'elasticsearch':
        package_url  => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb',
        java_install => true
    }

    exec { 'run-elasticsearch':
        require => Class['elasticsearch'],
        command => 'sh /usr/share/elasticsearch/bin/elasticsearch &'
    }
}
