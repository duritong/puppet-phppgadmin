# modules/phppgadmin/manifests/init.pp - manage phppgadmin stuff
# Copyright (C) 2007 admin@immerda.ch
#

class phppgadmin {
    case $::operatingsystem {
        gentoo: { include phppgadmin::gentoo }
        centos: { include phppgadmin::centos }
        default: { include phppgadmin::base }
    }
}
