# Download and unzip plugins from an array of urls
define mcommons::wordpress::install_plugins() {
  $url = $name
  $file = md5($url)

  exec { "Download plugin from ${url}":
    command => "/usr/bin/wget ${url} -O ${file}.zip",
    cwd     => "${::app_home}/plugins",
  }

  -> exec { "Extract ${file}.zip":
    command => "/usr/bin/unzip -o ${file}.zip",
    cwd     => "${::app_home}/plugins",
  }

  -> exec { "Cleanup ${file}.zip":
    command => "/bin/rm ${file}.zip",
    cwd     => "${::app_home}/plugins",
  }
  -> exec { "Set owner for ${file}.zip":
    command => "/bin/chown -R ${::runner_name}:${::runner_group} .",
    cwd     => "${::app_home}/plugins",
  }
}
