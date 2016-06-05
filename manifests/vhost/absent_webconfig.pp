# make sure the config the package installs
# is not anymore deployed
class phppgadmin::vhost::absent_webconfig {
  file{'/etc/httpd/conf.d/phpPgAdmin.conf':
    ensure  => absent,
    require => Package['phpPgAdmin'],
    notify  => Service['apache'],
  }
}
