class mcommons::memcached(
  $memory = 512,
) {

  require ::mcommons

  class { '::memcached':
    max_memory => $memory
  }
}
