class phppgadmin::vhost::absent_webconfig(
  $manage_shorewall = false
) {
  class{'phppgadmin':
    manage_shorewall => $manage_shorewall
  }
  file{'/etc/httpd/conf.d/phpPgAdmin.conf':
    ensure => absent,
    require => Package['phppgadmin'],
    notify => Service['apache'],
  }
}
