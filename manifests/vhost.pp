define phppgadmin::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $monitor_url = 'absent',
  $run_mode = 'absent',
  $run_uid = 'apache',
  $run_gid = 'apache',
  $logmode = 'default'
){
  include ::phppgadmin::vhost::absent_webconfig
  include ::apache::vhost::php::global_exec_bin_dir
  $documentroot = $operatingsystem ? {
    gentoo => '/var/www/localhost/htdocs/phppgadmin',
    default => '/usr/share/phpPgAdmin'
  }
  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domainalias,
    manage_docroot => false,
    path => $documentroot,
    logpath => $operatingsystem ? {
      gentoo => '/var/log/apache2/',
      default => '/var/log/httpd'
    },
    logmode => $logmode,
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    run_mode => $run_mode,
    run_uid => $run_uid,
    run_gid => $run_gid,
    template_partial => 'phppgadmin/vhost/php_stuff.erb',
    require => Package['phppgadmin'],
    php_settings => {
      open_basedir               => "${documentroot}/:/etc/phpPgAdmin/:/var/www/upload_tmp_dir/${name}/:/var/www/session.save_path/${name}/",
      upload_tmp_dir             => "/var/www/upload_tmp_dir/${name}/",
      'session.save_path'        => "/var/www/session.save_path/${name}",
      safe_mode_allowed_env_vars => 'PHP_,PG',
      safe_mode_exec_dir         => "/var/www/php_safe_exec_bins/${name}"
    },
    php_options => { safe_mode_exec_bins => [ '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ] },
    mod_security => false,
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
