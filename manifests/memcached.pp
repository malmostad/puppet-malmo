class malmo::memcached {
  class { '::memcached':
    max_memory => $::memcached_size
  }
}
