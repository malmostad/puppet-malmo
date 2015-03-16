class mcommons(
  $install_info = "${::runner_home}/install_info.txt"
) {
  class { '::locales':
    default_value => 'en_US.UTF-8',
    available     => ['en_US.UTF-8 UTF-8', 'sv_SE.UTF-8 UTF-8']
  }

  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update'
  }

  package {[
      'autoconf', 'bison', 'build-essential', 'libssl-dev',
      'htop',
    ]:
    ensure  => installed,
    require => Exec['apt-get-update'],
  }

  class { '::ntp':
    servers  => ['ntp.malmo.se'],
    restrict => ['127.0.0.1'],
  }

  if 'production' in $::envs {
    $dirs = [
      "${::runner_home}/${::app_name}",
      "${::runner_home}/${::app_name}/current",
      "${::runner_home}/${::app_name}/shared",
      "${::runner_home}/${::app_name}/shared/config"
    ]
    file { $dirs:
      ensure => 'directory',
      owner  => $::runner_name,
      group  => $::runner_group,
    }
  }

  file { $install_info:
    mode    => '0600',
    content => "Puppet install details\n======================\n\n"
  }
}
