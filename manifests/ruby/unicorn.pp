class mcommons::ruby::unicorn() {
  require ::mcommons::ruby

  # Parse and copy init.d script
  file { "unicorn-init":
    path    => "/etc/init.d/unicorn-${::app_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('mcommons/unicorn.erb'),
  }
}
