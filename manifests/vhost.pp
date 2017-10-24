# webhost for phppgadmin
define phppgadmin::vhost(
  $ensure        = 'present',
  $domainalias   = 'absent',
  $ssl_mode      = 'force',
  $monitor_url   = 'absent',
  $run_mode      = 'absent',
  $run_uid       = 'apache',
  $run_gid       = 'apache',
  $logmode       = 'default',
  $manage_nagios = false,
  $configuration = {},
){

  $documentroot = '/usr/share/phpPgAdmin'

  if ($run_mode == 'fcgid'){
    if (($run_uid == 'absent') or ($run_gid == 'absent')) {
      fail("Need to configure \$run_uid and \$run_gid if you want to run Phppgadmin::Vhost[${name}] as fcgid.")
    }

    user::managed{$name:
      ensure     => $ensure,
      uid        => $run_uid,
      gid        => $run_gid,
      managehome => false,
      shell      => '/sbin/nologin',
      homedir    => $documentroot,
      before     => Apache::Vhost::Php::Standard[$name],
    }
  }
  include ::phppgadmin
  include ::phppgadmin::vhost::absent_webconfig

  $additional_open_basedir = "/etc/phpPgAdmin/"
  $php_settings = {
    'upload_tmp_dir'    => "/var/www/upload_tmp_dir/${name}/",
    'session.save_path' => "/var/www/session.save_path/${name}",
  }
  if versioncmp($::operatingsystemmajrelease,'7') < 0 {
    $real_php_settings = merge($php_settings, {
      'safe_mode_allowed_env_vars' => 'PHP_,PG',
      'safe_mode_exec_dir'         => "/var/www/php_safe_exec_bins/${name}",
    })
    $php_options = {
      'safe_mode_exec_bins'   => [ '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ],
      additional_open_basedir => $additional_open_basedir,
    }
    include ::apache::vhost::php::global_exec_bin_dir
  } else {
    $php_options = { additional_open_basedir => $additional_open_basedir }
    $real_php_settings = $php_settings
  }
  apache::vhost::php::standard{$name:
    ensure           => $ensure,
    domainalias      => $domainalias,
    manage_docroot   => false,
    path             => $documentroot,
    logpath          => '/var/log/httpd',
    logprefix        => "${name}-",
    logmode          => $logmode,
    manage_webdir    => false,
    path_is_webdir   => true,
    ssl_mode         => $ssl_mode,
    configuration    => $configuration,
    run_mode         => $run_mode,
    run_uid          => $name,
    run_gid          => $name,
    template_partial => 'apache/vhosts/php/partial.erb',
    require          => Package['phpPgAdmin'],
    php_settings     => $real_php_settings,
    php_options      => $php_options,
    mod_security     => false,
    additional_options => '<Directory /usr/share/phpPgAdmin/>
    <IfModule mod_authz_core.c>
      # Apache 2.4
      <RequireAny>
        Require all granted
      </RequireAny>
    </IfModule>
    <IfModule !mod_authz_core.c>
      # Apache 2.2
      Order Deny,Allow
      Allow from All
    </IfModule>
  </Directory>'
  }

  if $manage_nagios {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default  => $monitor_url,
    }
    nagios::service::http{$real_monitor_url:
      ensure   => $ensure,
      ssl_mode => $ssl_mode,
    }
  }
}
