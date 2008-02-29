# modules/phppgadmin/manifests/init.pp - manage phppgadmin stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "phppgadmin": }

class phppgadmin {

    case $operatingsystem {
        gentoo: { include webapp-config }
    }
    
    package { 'phppgadmin':
        ensure => present,
        category => $operatingsystem ? {
            gentoo => 'dev-db',
            default => '',
        }
    }

    # config files
    file{
        "/var/www/localhost/htdocs/phppgadmin/conf/config.inc.php":
            source => [
                "puppet://$server/dist/phppgadmin/${fqdn}/config.inc.php",
                "puppet://$server/phppgadmin/${fqdn}/config.inc.php",
                "puppet://$server/phppgadmin/config.inc.php"
            ],
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[phppgadmin],
    }
}
