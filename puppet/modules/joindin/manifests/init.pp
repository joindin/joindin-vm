# 'site' module.
class joindin {

    # add dotdeb repository
    include joindin::dotdeb

    Exec["update-apt"] -> Package <| |>


    # Install some default packages
    $default_packages = [ "strace", "sysstat", "git", "vim"]
    package { $default_packages :
        ensure => present,
        require => Exec['update-apt'],
    }
    
    include joindin::sql
    include joindin::web
    include joindin::app
    include joindin::test
    include joindin::mailcatcher
    include joindin::node
    include joindin::elastic
}
