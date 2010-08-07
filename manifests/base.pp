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
                "puppet:///modules/site-phppgadmin/${fqdn}/config.inc.php",
                "puppet:///modules/site-phppgadmin/config.inc.php",
                "puppet:///modules/phppgadmin/config.inc.php"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[phppgadmin],
    }

}
