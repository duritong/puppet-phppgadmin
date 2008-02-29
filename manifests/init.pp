# modules/phppgadmin/manifests/init.pp - manage phppgadmin stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "phppgadmin": }

class phppgadmin {

    case $operatingsystem {
        gentoo: { include webapp-config }
    }
    
    $modulename = "phppgadmin"
    $pkgname = "phppgadmin"
    $gentoocat = "dev-db"
    $cnfname = "config.inc.php"
    $cnfpath = "/var/www/localhost/htdocs/phppgadmin/conf"

    package { $pkgname:
        ensure => present,
        category => $operatingsystem ? {
            gentoo => $gentoocat,
            default => '',
        }
    }

    file{
        "${cnfpath}/${cnfname}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${cnfname}"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
    }

}

