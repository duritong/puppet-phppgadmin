class phppgadmin::base {
  include php
  include php::extensions::pgsql
  class{'postgres::client':
    manage_shorewall => $phppgadmin::manage_shorewall,
  }

  package { phppgadmin:
    ensure => present,
    require => Package[php],
  }

  file{ phppgadmin_config:
    path => "/var/www/localhost/htdocs/phppgadmin/conf/config.inc.php",
    source => [
      "puppet:///modules/site_phppgadmin/${::fqdn}/config.inc.php",
      "puppet:///modules/site_phppgadmin/config.inc.php",
      "puppet:///modules/phppgadmin/config.inc.php"
    ],
    ensure => file,
    owner => root,
    group => 0,
    mode => 0444,
    require => Package[phppgadmin],
  }
}
