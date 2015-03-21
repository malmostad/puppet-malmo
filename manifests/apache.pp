class mcommons::apache(
  $ssl                     = true,
  $force_ssl               = true,
  $php                     = false,
  $generate_snakeoil_certs = false,
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
    ::apache::vhost { "${::fqdn}-80":
      docroot          => $::app_home,
      fallbackresource => '/index.php',
      rewrites         => [ {
        rewrite_cond => ['%{HTTPS} off'],
        rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]'],
      } ]
    }
  }
  else {
    ::apache::vhost { "${::fqdn}-80":
      docroot          => $::app_home,
      fallbackresource => '/index.php',
    }
  }


  if $ssl {
    if $generate_snakeoil_certs {
      $cert_base_name = "${::fqdn}-snakeoil"
      require ::mcommons::generate_snakeoil_certs
    } else {
      $cert_base_name = $::fqdn
    }


    ::apache::vhost { "${::fqdn}-443":
      port             => '443',
      docroot          => $::app_home,
      fallbackresource => '/index.php',
      ssl              => true,
      ssl_cert         => "/etc/ssl/certs/${cert_base_name}.crt",
      ssl_key          => "/etc/ssl/private/${cert_base_name}.key",
    }
  }
}
