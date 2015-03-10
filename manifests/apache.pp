class malmo::apache {

  class { '::apache':
    # default_vhost => false,
    mpm_module    => 'prefork',
  }

  ::apache::vhost { 'example.com':
    docroot  => '/home/vagrant',
  }
}
