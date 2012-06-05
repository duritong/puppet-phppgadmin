class phppgadmin::gentoo inherits phppgadmin::base {

  require webapp_config

  Package[phppgadmin]{
    category => 'dev-db',
  }
}
