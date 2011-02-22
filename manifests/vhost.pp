define phppgadmin::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $monitor_url = 'absent'
){
  include ::phppgadmin::vhost::absent_webconfig
  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domanalias,
    manage_docroot => false,
    path => $operatingsystem ? {
      gentoo => '/var/www/localhost/htdocs/phppgadmin',
      default => '/usr/share/phpPgAdmin'
    },
    logpath => $operatingsystem ? {
      gentoo => '/var/log/apache2/',
      default => '/var/logs/httpd'
    },
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    template_partial => 'phppgadmin/vhost/php_stuff.erb',
    require => Package['phpPgAdmin'],
  }

  if $use_nagios {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default => $monitor_url,
    }
    nagios::service::http{"${real_monitor_url}":
      ensure => $ensure,
      ssl_mode => $ssl_mode,
    }
  }
}
