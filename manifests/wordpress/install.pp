class mcommons::wordpress::install(
  $tar_gz_url = 'https://sv.wordpress.org/latest-sv_SE.tar.gz',
) {
  $archive = 'wordpress.tar.gz'

  exec { "Download Wordpress from ${$tar_gz_url}":
    command => "/usr/bin/wget ${$tar_gz_url} -O ${archive}",
    cwd     => $::runner_home,
  }

  -> exec { 'Extract Wordpress':
    command => "/bin/tar zxvf ${archive} --exclude wp-content/themes --exclude wp-content/plugins",
    cwd     => $::runner_home,
  }

  -> exec { 'Cleanup installer':
    command => "/bin/rm ${archive}",
    cwd     => $::runner_home,
  }

  -> exec { 'Set owner':
    command => "/bin/chown -R ${::runner_name}:${::runner_group} ./wordpress",
    cwd     => $::runner_home,
  }
}
