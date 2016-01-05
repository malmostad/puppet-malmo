class mcommons::elasticsearch(
  $version = '1.7',
  $memory  = '512m'
) {
  require ::mcommons

  class { '::elasticsearch':
    status       => 'enabled',
    manage_repo  => true,
    repo_version => $version,
    java_install => true,
    config       => {
      'network.host' => '127.0.0.1',
    },
  } ->

  ::elasticsearch::instance { 'es-01': } ->

  file_line { 'Set heap size for ElasticSearch':
    path  => '/etc/init.d/elasticsearch-es-01',
    line  => "ES_HEAP_SIZE=${memory}",
    match => 'ES_HEAP_SIZE\s*=',
  }

  ::logrotate::rule { 'elasticsearch':
    path          => '/var/log/elasticsearch/es-01',
    rotate        => 52,
    rotate_every  => 'week',
    missingok     => true,
    compress      => true,
    delaycompress => true,
    ifempty       => false,
  }
}
