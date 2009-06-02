class phppgadmin::centos inherits phppgadmin::base {
    Package[phppgadmin]{
        name => 'phpPgAdmin',
        require +> Package[php-pgsql],
    }

    File[phppgadmin_config]{
        path => '/etc/phpPgAdmin/config.inc.php',
    }
}
