class phppgadmin::gentoo inherits phppgadmin::base {

    include webapp-config

    Package[phppgadmin]{
        category => 'dev-db',
        require => Package[webapp-config],
    }
}
