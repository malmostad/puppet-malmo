define mcommons::ruby::db_migrate() {
  require ::mcommons::ruby
  require ::mcommons::mysql

  exec { "Migrate database ${name}":
    command => "bundle exec rake db:schema:load RAILS_ENV=${name}",
    user    => $::runner_name,
    path    => $::runner_path,
    cwd     => $::app_home,
  }
}
