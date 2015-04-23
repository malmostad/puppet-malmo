define mcommons::ruby::db_load_schema() {
  require ::mcommons::ruby
  require ::mcommons::mysql

  exec { "Load schema to database ${name}":
    command => "bundle exec rake db:schema:load RAILS_ENV=${name}",
    user    => $::runner_name,
    path    => $::runner_path,
    cwd     => $::app_home,
  }
}
