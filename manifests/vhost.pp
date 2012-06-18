define phppgadmin::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $monitor_url = 'absent',
  $run_mode = 'absent',
  $run_uid = 'apache',
  $run_gid = 'apache',
  $logmode = 'default',
  $manage_nagios = false
){

  $documentroot = $::operatingsystem ? {
    gentoo => '/var/www/localhost/htdocs/phppgadmin',
    default => '/usr/share/phpPgAdmin'
  }

  if ($run_mode == 'fcgid'){
    if (($run_uid == 'absent') or ($run_gid == 'absent')) { fail("Need to configure \$run_uid and \$run_gid if you want to run Phppgadmin::Vhost[${name}] as fcgid.") }

    user::managed{$name:
      ensure => $ensure,
      uid => $run_uid,
      gid => $run_gid,
      managehome => false,
      homedir => $documentroot,
      shell => $::operatingsystem ? {
        debian => '/usr/sbin/nologin',
        ubuntu => '/usr/sbin/nologin',
        default => '/sbin/nologin'
      },
      before => Apache::Vhost::Php::Standard[$name],
    }
  }
  include ::phppgadmin::vhost::absent_webconfig
  include ::apache::vhost::php::global_exec_bin_dir
  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domainalias,
    manage_docroot => false,
    path => $documentroot,
    logpath => $::operatingsystem ? {
      gentoo => '/var/log/apache2/',
      default => '/var/log/httpd'
    },
    logmode => $logmode,
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    run_mode => $run_mode,
    run_uid => $name,
    run_gid => $name,
    template_partial => 'apache/vhosts/php/partial.erb',
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

  if $manage_nagios {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default => $monitor_url,
    }
    nagios::service::http{$real_monitor_url:
      ensure => $ensure,
      ssl_mode => $ssl_mode,
    }
  }
}
