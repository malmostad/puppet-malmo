class mcommons::ruby::rails() {
  require ::mcommons::ruby

  file { "database":
    path    => "${::app_config_dir}/database.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_database.yml.erb'),
  }

  file { "secrets":
    path    => "${::app_config_dir}/secrets.yml",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0755',
    content => template('mcommons/rails_secrets.yml.erb'),
  }

  # file { "app":
  #   path    => "${::app_config_dir}/app_config.yml",
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
