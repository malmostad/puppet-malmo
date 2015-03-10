define malmo::mysql::backup($db_name) {
  class { '::mysql::server::backup':
    ensure          => present,
    backupdatabases => [$db_name],
    backupuser      => 'backup_runner',
    backuppassword  => $::db[backup_password],
    backupdir       => $::db[backup_dir],
    time            => $::db[backup_time],
    backuprotate    => '60',
    backupcompress  => true,
  }
}
