class malmo::ruby {
  require ::malmo::system

  package {[
      'libgdbm3', 'libgdbm-dev',
    ]:
    ensure  => installed,
  }

  class { '::rbenv':
    install_dir => "${::runner_home}/.rbenv",
    owner       => $::runner_name,
    group       => $::runner_group,
  }
  ::rbenv::plugin { 'sstephenson/ruby-build': }
  ::rbenv::build { $::ruby_version: global => true }
  ::rbenv::gem { 'bundle': ruby_version => $::ruby_version }
}
