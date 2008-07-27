# modules/phppgadmin/manifests/init.pp - manage phppgadmin stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "phppgadmin": }

class phppgadmin {

    case $operatingsystem {
        gentoo: { include phppgadmin::gentoo }
        centos: { include phppgadmin::centos }
        default: { include phppgadmin::base }
    }
}    

class phppgadmin::base {
    package { phppgadmin:
        ensure => present,
        require => Package[php],
    }

    file{ phppgadmin_config:
            path => "/var/www/localhost/htdocs/phppgadmin/conf/config.inc.php",
            source => [
                "puppet://$server/files/phppgadmin/${fqdn}/config.inc.php",
                "puppet://$server/files/phppgadmin/config.inc.php",
                "puppet://$server/phppgadmin/config.inc.php"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[phppgadmin],
    }

}

class phppgadmin::gentoo inherits phppgadmin::base {

    include webapp-config

    Package[phppgadmin]{
        category => 'dev-db',
        require => Package[webapp-config],
    }
}

class phppgadmin::centos inherits phppgadmin::base {
    Package[phppgadmin]{
        name => 'phpPgAdmin',
        require +> Package[php-pgsql],
    }

    File[phppgaadmin_config]{
        path => '/etc/phpPgAdmin/config.inc.php',
    }
}
