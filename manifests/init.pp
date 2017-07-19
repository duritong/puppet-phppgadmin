# manage the basis of a phppgadmin
class phppgadmin(
  $servers = [
    { 'host' => 'localhost' },
  ],
) {
  include ::php
  include ::php::extensions::pgsql
  if versioncmp($::puppetversion,'4.0') >= 0 {
    include ::postgresql::client
  } else {
    ensure_packages(['postgresql'])
  }

  package{'phpPgAdmin':
    ensure  => installed,
    require => Package['php','php-pgsql'],
  } -> file{'/etc/phpPgAdmin/config.custom.php':
    content => template('phppgadmin/config.custom.php.erb'),
    owner   => root,
    group   => 0,
    mode    => '0444',
  } -> file_line{'phppgadmin_config_include':
    path  => '/etc/phpPgAdmin/config.inc.php',
    line  => 'require(\'config.custom.php\');',
    after => '.*conf\[\'version\'\] = .*',
  }
}
