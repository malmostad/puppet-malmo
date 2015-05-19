class mcommons::monit() {
  require ::mcommons

  exec { 'monit-install':
    command => '/usr/bin/apt-get install -qq monit',
  }

  -> file { "monitrc":
    path    => "/etc/monit/monitrc",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('mcommons/monitrc.erb'),
  }

  -> exec { 'Start monit':
    command => '/etc/init.d/monit start',
  }
}
