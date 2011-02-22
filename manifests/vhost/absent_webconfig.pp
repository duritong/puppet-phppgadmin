class phppgadmin::vhost::absent_webconfig {
  include ::phppgadmin
  file{'/etc/httpd/conf.d/phpPgAdmin.conf':
    ensure => absent,
    require => Package['phppgadmin'],
    notify => Service['apache'],
  }
}
