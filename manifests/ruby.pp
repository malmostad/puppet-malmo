class mcommons::ruby(
  $version = '2.2.1'
) {
  require ::mcommons

  package {[
      'libgdbm3', 'libgdbm-dev', 'libcurl4-gnutls-dev'
    ]:
    ensure  => installed,
  } ->

  class { '::rbenv':
    install_dir => "${::runner_home}/.rbenv",
    owner       => $::runner_name,
    group       => $::runner_group,
  }
  ::rbenv::plugin { 'sstephenson/ruby-build': }
  ::rbenv::build { $version: global => true }
  ::rbenv::gem { 'bundle': ruby_version => $version }
}
