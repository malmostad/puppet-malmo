class mcommons::apache(
  $ssl            = true,
  $force_ssl      = true,
  $port           = 80,
  $ssl_port       = 443,
  $serverlimit    = 512,
  $maxclients     = 512,
  $snakeoil       = false,
  $php            = false,
  $opcache        = 'On',
  $opcache_memory = 128,
  $opcache_files  = 4000,
) {
  require ::mcommons

  class { '::apache':
    default_vhost          => false,
    keepalive              => 'On',
    keepalive_timeout      => 15,
    max_keepalive_requests => 100,
    mpm_module             => false,
    default_charset        => 'utf-8',
  }

  if $php {
    class { '::apache::mod::prefork':
      serverlimit => $serverlimit,
      maxclients  => $maxclients,
    } ->
    class { '::apache::mod::php': } ->

    file { '/etc/php5/mods-available/opcache.ini':
      replace => true,
      content => "; Puppet generated
zend_extension=opcache.so
opcache.enable=${opcache}
opcache.memory_consumption=${opcache_memory}
opcache.max_accelerated_files=${opcache_files}
",
    }

    $directory_index = 'index.php index.html'
    $mpm_module      = 'prefork'
  } else {
    $directory_index = 'index.html'
    $mpm_module      = 'worker'

    class { '::apache::mod::worker':
      maxclients  => '512',
    }
  }

  if $force_ssl {
    if $ssl_port == 443 {
      $add_ssl_port = ''
    } else {
      $add_ssl_port = ":${ssl_port}"
    }

    $rewrites = [ {
      rewrite_cond => ['%{HTTPS} off'],
      rewrite_rule => ["(.*) https://%{SERVER_NAME}${add_ssl_port}%{REQUEST_URI} [R=301,L]"],
    } ]
  } else {
    $rewrites = [ {} ]
  }

  ::apache::vhost { $::app_name:
    servername     => $::fqdn,
    docroot        => $::doc_root,
    port           => $port,
    directoryindex => $directory_index,
    headers        => ['Set X-UA-Compatible "IE=Edge,chrome=1"'],
    override       => 'All',
    rewrites       => $rewrites,
  }

  if $ssl {
    if $snakeoil {
      $cert_base_name = "${::fqdn}-snakeoil"
      require ::mcommons::snakeoil
    } else {
      $cert_base_name = $::fqdn
    }

    ::apache::vhost { "${::app_name}-ssl":
      servername     => $::fqdn,
      port           => $ssl_port,
      docroot        => $::app_home,
      directoryindex => $directory_index,
      headers        => ['Set X-UA-Compatible "IE=Edge,chrome=1"'],
      override       => 'All',
      ssl            => true,
      ssl_cert       => "/etc/ssl/certs/${cert_base_name}.crt",
      ssl_key        => "/etc/ssl/private/${cert_base_name}.key",
    }
  }
}
