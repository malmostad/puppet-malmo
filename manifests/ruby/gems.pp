class mcommons::ruby::gems() {
  require ::mcommons::ruby

  exec { 'bundle-install-gems':
    command => 'bundle install',
    user    => $::runner_name,
    path    => $::runner_path,
    cwd     => $::app_home,
    timeout => 1000,
  }
}
