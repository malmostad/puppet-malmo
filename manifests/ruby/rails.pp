class mcommons::ruby::rails() {
  require ::mcommons::ruby

  if 'production' in $::envs {
    $config_dir = "${::runner_home}/${::app_name}/shared/config"

    $create_dirs = [
      "${::runner_home}/deploy_dump",
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

  file { 'database':
    path    => "${config_dir}/database.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_database.yml.erb'),
  }

  file { 'secrets':
    path    => "${config_dir}/secrets.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_secrets.yml.erb'),
  }

  ::logrotate::rule { $::app_name:
    path          => "${::runner_home}/${::app_name}/shared/log/*.log",
    rotate        => 260,
    rotate_every  => 'week',
    missingok     => true,
    compress      => true,
    delaycompress => true,
    copytruncate  => true,
    ifempty       => false,
    # raises error, add manually
    # su            => true,
    # su_owner      => $::runner_name,
    # su_group      => $::runner_group,
    create        => true,
    create_owner  => $::runner_name,
    create_group  => $::runner_group,
    create_mode   => '0640',
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
