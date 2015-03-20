class mcommons::ruby::unicorn() {
  require ::mcommons::ruby

  # Parse and copy init.d script
  file { "unicorn-init":
    path    => "/etc/init.d/unicorn_${::app_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('mcommons/unicorn.erb'),
  } ->

  exec { 'Add unicorn to reboot tasks':
    command => "/usr/sbin/update-rc.d unicorn_${::app_name} defaults",
  }
}
