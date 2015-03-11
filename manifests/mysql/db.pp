define mcommons::mysql::db(
  $db_name,
  $db_user,
  $db_password
) {
  ::mysql::db { $db_name:
    ensure   => present,
    user     => $db_user,
    password => $db_password,
    host     => 'localhost',
    grant    => ['ALL'],
    charset  => 'utf8',
    collate  => 'utf8_swedish_ci',
  }

  file_line { "Database ${db_name} created for user ${db_user}":
    path => $::mcommons::install_info,
    line => "Database ${db_name} created for user ${db_user} with password '${db_password}'",
  }
}
