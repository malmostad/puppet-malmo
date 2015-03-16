class mcommons::ruby::rails() {
  require ::mcommons::ruby
  include nodejs

  if 'production' in $::envs {
    $config_dir = "${::runner_home}/${::app_name}/shared/config"

    $create_dirs = [
      "${::runner_home}/${::app_name}",
      "${::runner_home}/${::app_name}/current",
      "${::runner_home}/${::app_name}/shared",
      $config_dir
    ]

    file { $create_dirs:
      ensure => 'directory',
      owner  => $::runner_name,
      group  => $::runner_group,
    }
  }
  else {
    $config_dir = '/vagrant/config'
  }

  file { "database":
    path    => "${config_dir}/database.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_database.yml.erb'),
  }

  file { "secrets":
    path    => "${config_dir}/secrets.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_secrets.yml.erb'),
  }

  # file { "app":
  #   path    => "${config_dir}/app_config.yml",
      # owner   => $::runner_name,
      # group   => $::runner_group,
  #   # mode    => '0755',
  #   content => template('mcommons/rails/app_config.erb'),
  # }

  file_line { 'Please edit the apps config file':
    path => $mcommons::install_info,
    line => "Please edit the apps config file: ${::app_home}/config/app_config.yml",
  }
}
