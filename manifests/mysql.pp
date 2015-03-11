class mcommons::mysql(
  $db_name          = $::app_name,
  $db_user          = $::app_name,
  $db_password      = inline_template('<%= SecureRandom.hex(rand(12..24)) -%>'),
  $db_root_password = inline_template('<%= SecureRandom.hex(rand(12..24)) -%>'),
  $create_test_db   = false,
  $daily_backup     = true,
  $backup_user      = 'backup_runner',
  $backup_password  = inline_template('<%= SecureRandom.hex(rand(12..24)) -%>'),
  $backup_time      = ['3', '45'],
  $backup_dir       = "${::app_home}/db_backups"
) {
  require ::mcommons

  package { 'libmysqlclient-dev':}

  class { '::mysql::bindings':
    ruby_enable => true
  }

  class { '::mysql::server':
    root_password   => $db_root_password,
    # remove_default_accounts => true,
    service_enabled => true,
    service_manage  => true,
  } ->

  file_line { 'Password for DB user root':
    path => $::mcommons::install_info,
    line => "Password for DB user root: '${db_root_password}'",
  } ->

  ::mcommons::mysql::db { 'create_db':
    db_name     => $db_name,
    db_user     => $db_user,
    db_password => $db_password,
  }

  if $create_test {
    ::mcommons::mysql::db { 'create_test_db':
      db_name     => "${db_name}_test",
      db_user     => $db_user,
      db_password => $db_password,
    }
  }

  if $daily_backup {
    class { '::mysql::server::backup':
      ensure          => present,
      backupdatabases => [$db_name],
      backupuser      => $backup_user,
      backuppassword  => $backup_password,
      backupdir       => $backup_dir,
      time            => $backup_time,
      backuprotate    => '60',
      backupcompress  => true,
    }

    file_line { "Password for DB user ${backup_user}":
      path => $::mcommons::install_info,
      line => "Password for DB backup user ${backup_user}: '${backup_password}'",
    }
  }
}
