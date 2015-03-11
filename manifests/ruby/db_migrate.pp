define mcommons::ruby::db_migrate(
  $envs = ['development', 'test']
) {
  require ::mcommons::ruby
  require ::mcommons::mysql

  $envs.each |$env| {
    exec { "Migrate database ${env}":
      command => "bundle exec rake db:migrate RAILS_ENV=${env}",
      user    => $::runner_name,
      path    => $::runner_path,
      cwd     => $::app_home,
    }
  }
}
