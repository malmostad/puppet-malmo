class mcommons::apache(
  $ssl                     = true,
  $force_ssl               = true,
  $php                     = false,
  $snakeoil_certs = false,
) {
  require ::mcommons

  class { '::apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }

  if $php {
    class { '::apache::mod::php': }
  }

  if $force_ssl {
    ::apache::vhost { $::app_name:
      servername       => $::fqdn,
      port             => '80',
      docroot          => $::app_home,
      fallbackresource => '/index.php',
      override         => 'All',
      rewrites         => [ {
        rewrite_cond => ['%{HTTPS} off'],
        rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]'],
      } ]
    }
  }
  else {
    ::apache::vhost { $::app_name:
      servername       => $::fqdn,
      port             => '80',
      docroot          => $::app_home,
      override         => 'All',
      fallbackresource => '/index.php',
    }
  }


  if $ssl {
    if $snakeoil_certs {
      $cert_base_name = "${::fqdn}-snakeoil"
      require ::mcommons::snakeoil_certs
    } else {
      $cert_base_name = $::fqdn
    }

    ::apache::vhost { "${::app_name}-ssl":
      servername       => $::fqdn,
      port             => '443',
      docroot          => $::app_home,
      fallbackresource => '/index.php',
      override         => 'All',
      ssl              => true,
      ssl_cert         => "/etc/ssl/certs/${cert_base_name}.crt",
      ssl_key          => "/etc/ssl/private/${cert_base_name}.key",
    }
  }
}
