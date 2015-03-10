class malmo::mysql {
  package { 'libmysqlclient-dev':}

  class { '::mysql::bindings':
    ruby_enable => true
  }

  class { '::mysql::server':
    root_password   => $::db[root_password],
    # remove_default_accounts => true,
    service_enabled => true,
    service_manage  => true,
  } ->

  file_line { 'Password for DB user root':
    path => $::install_info,
    line => "Password for DB user root: '${::db[root_password]}'",
  } ->

  file_line { 'Password for DB user':
    path => $::install_info,
    line => "Password for DB user ${::db[user]}: '${::db[password]}'",
  } ->

  ::malmo::mysql::db { 'create_db':
    db_name => $::db[name]
  } ->

  file_line { 'Database created':
    path => $::install_info,
    line => "Database created: '${::db[name]}'",
  }

  if $::db[create_test] {
    ::malmo::mysql::db { 'create_test_db':
      db_name => "${::db[name]}_test"
    }
    file_line { 'Test database created':
      path => $::install_info,
      line => "Test database created: '${::db[name]}_test'",
    }
  }

  if $::db[daily_backup] {
    ::malmo::mysql::backup { 'backup_main_db':
      db_name => $::db[name],
    } ->

    file_line { 'Password for DB user backup_runner':
      path => $::install_info,
      line => "Password for DB user backup_runner: '${::db[backup_password]}'",
    }
  }
}
