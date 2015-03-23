class mcommons::wordpress(
  $tar_gz_url = 'https://sv.wordpress.org/latest-sv_SE.tar.gz',
) {
  require ::mcommons::apache

  class { '::mcommons::wordpress::install':
    tar_gz_url => $tar_gz_url
  }

  # Parse and copy wp-config
  -> file { 'Add Wordpress config file':
    path    => "${::app_home}/wp-config.php",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0644',
    content => template('mcommons/wp-config.php.erb'),
  }

  # Create uploads dir if not there
  -> file { "${::runner_home}/wordpress-uploads":
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
  }

  # Symlink uploads directory
  -> file { "${::app_home}/wp-content/uploads":
    ensure => 'link',
    target => "${::runner_home}/wordpress-uploads",
    owner  => $::runner_name,
    group  => $::runner_group,
  }

  # Capistrano catalog structure
  -> file { ["${::runner_home}/wordpress-deployed", "${::runner_home}/wordpress-deployed/current"]:
    ensure => 'directory',
    owner  => $::runner_name,
    group  => $::runner_group,
  }

  # Symlink themes directory
  -> file { "${::app_home}/wp-content/themes":
    ensure => 'link',
    force  => true,
    target => "${::runner_home}/wordpress-deployed/current/themes",
    owner  => $::runner_name,
    group  => $::runner_group,
  }

  # Symlink plugins directory
  -> file { "${::app_home}/wp-content/plugins":
    ensure => 'link',
    force  => true,
    target => "${::runner_home}/wordpress-deployed/current/plugins",
    owner  => $::runner_name,
    group  => $::runner_group,
  }
}
