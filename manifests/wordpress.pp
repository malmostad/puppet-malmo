class mcommons::wordpress(
  $tar_gz_url = 'https://sv.wordpress.org/latest-sv_SE.tar.gz',
) {
  # require ::mcommons::apache

  $archive = 'wordpress.tar.gz'

  exec { "Download Wordpress from ${$tar_gz_url}":
    command => "/usr/bin/wget ${$tar_gz_url} -O ${archive}",
    cwd     => $::runner_home,
  } ->

  exec { 'Extract Wordpress':
    command => "/bin/tar zxvf ${archive}",
    cwd     => $::runner_home,
    user    => $::runner_name,
    group   => $::runner_group,
  } ->

  exec { "Delete ${archive}":
    command => "/bin/rm ${archive}",
    cwd     => $::runner_home,
  } ->

  # exec { 'Change ownership of wordpress uploads dir':
  #   command => "/bin/chown -R www-data:www-data ${::app_home}/wp-content/uploads",
  # } ->

  # file { "${::runner_home}/wordpress-uploads":
  #   ensure => 'directory',
  # } ->

  # Symlink uploads directory
  file { "${::runner_home}/wordpress-uploads":
    ensure => 'link',
    force  => true,
    target => "${::app_home}/wp-content/uploads",
    owner  => $::runner_name,
    group  => $::runner_group,
  } ->

  # file { "${::runner_home}/wordpress-themes":
  #   ensure => 'directory',
  # } ->

  # Symlink uploads directory
  file { "${::runner_home}/wordpress-themes":
    ensure => 'link',
    force  => true,
    target => "${::app_home}/wp-content/themes",
    owner  => $::runner_name,
    group  => $::runner_group,
  } ->

  # file { "${::runner_home}/wordpress-plugins":
  #   ensure => 'directory',
  # } ->

  # Symlink uploads directory
  file { "${::runner_home}/wordpress-plugins":
    ensure => 'link',
    force  => true,
    target => "${::app_home}/wp-content/plugins",
    owner  => $::runner_name,
    group  => $::runner_group,
  }
}
