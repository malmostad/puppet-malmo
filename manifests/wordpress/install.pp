class mcommons::wordpress::install(
  $tar_gz_url = 'https://sv.wordpress.org/latest-sv_SE.tar.gz',
) {
  $archive_file = 'wordpress.tar.gz'

  exec { "Download Wordpress from ${$tar_gz_url}":
    command => "/usr/bin/wget ${$tar_gz_url} -O ${archive_file}",
    cwd     => $::runner_home,
    user    => $::runner_name,
    group   => $::runner_group,
  }

  -> exec { 'Extract Wordpress':
    command => "/bin/tar zxvf ${archive_file} --exclude wp-content/themes --exclude wp-content/plugins",
    cwd     => $::runner_home,
    user    => $::runner_name,
    group   => $::runner_group,
  }

  -> exec { 'Cleanup installer':
    command => "/bin/rm ${archive_file}",
    cwd     => $::runner_home,
  }

  -> exec { 'Set owner':
    command => "/bin/chown -R ${::runner_name}:${::runner_group} ./wordpress",
    cwd     => $::runner_home,
  }
}
