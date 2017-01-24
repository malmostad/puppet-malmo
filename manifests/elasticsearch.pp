class mcommons::elasticsearch(
  $version = '5.x',
  $memory  = '2g'
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
    jvm_options  => [
      "-Xms${memory}",
      "-Xmx${memory}",
    ],
  } ->

  ::elasticsearch::instance { 'es-01': } ->

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
