class mcommons::wordpress(
  $tar_gz_url = 'https://sv.wordpress.org/latest-sv_SE.tar.gz',
  $plugins      = [],
  $table_prefix = 'wp_',
) {

  class { '::mcommons::wordpress::install':
    tar_gz_url => $tar_gz_url,
  }

  ::mcommons::wordpress::install_plugins { $plugins: }

  # Generate wp-config
  -> file { 'Add Wordpress config file':
    path    => "${::doc_root}/wp-config.php",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0644',
    content => template('mcommons/wp-config.php.erb'),
  }

  # Generate .htaccess
  -> file { 'Add Wordpress .htaccess file':
    path    => "${::doc_root}/.htacess",
    owner   => $::runner_name,
    group   => $::runner_group,
    mode    => '0644',
    content => template('mcommons/wp-htaccess.erb'),
  }

  # Create uploads dir
  -> file { "${::runner_home}/wordpress-uploads":
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
  }

  # Symlink uploads directory
  -> file { "${::doc_root}/wp-content/uploads":
    ensure => 'link',
    target => "${::runner_home}/wordpress-uploads",
    owner  => $::runner_name,
    group  => $::runner_group,
  }

  # Symlink themes directory
  -> file { "${::doc_root}/wp-content/themes":
    ensure => 'link',
    target => "${::app_home}/themes",
    owner  => $::runner_name,
    group  => $::runner_group,
  }

  # Symlink plugins directory
  -> file { "${::doc_root}/wp-content/plugins":
    ensure => 'link',
    target => "${::app_home}/plugins",
    owner  => $::runner_name,
    group  => $::runner_group,
  }
}
