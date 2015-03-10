class malmo::nginx {
  apt::ppa { 'ppa:nginx/stable': }

  exec { 'nginx-install':
    command => '/usr/bin/apt-get install -qq nginx',
    require => Class['::malmo::system']
  }

  # Parse and copy the conf file
  file { "nginx_conf":
    path    => "/etc/nginx/sites-available/${::app_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('malmo/nginx.erb'),
    require => Exec['nginx-install'],
  }

  # Symlink to the conf file
  file { "/etc/nginx/sites-enabled/${::app_name}":
    ensure => 'link',
    target => "/etc/nginx/sites-available/${::app_name}",
    require => Exec['nginx-install'],
  }

  # Remove default conf
  file { "/etc/nginx/sites-enabled/default":
    ensure => 'absent',
    require => Exec['nginx-install'],
  }
}
