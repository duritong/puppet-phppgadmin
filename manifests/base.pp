class phppgadmin::base {
    include php
    include php::extensions::pgsql
    include postgres::client

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
