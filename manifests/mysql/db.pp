define malmo::mysql::db($db_name) {
  ::mysql::db { $db_name:
    ensure   => present,
    user     => $::db[user],
    password => $::db[password],
    host     => 'localhost',
    grant    => ['ALL'],
    charset  => 'utf8',
    collate  => 'utf8_swedish_ci',
  }
}
