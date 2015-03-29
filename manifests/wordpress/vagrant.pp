class mcommons::wordpress::vagrant(
  $capistrano_tasks = [],
) {
  exec { 'Install Bundler':
    command => '/usr/bin/env gem install bundler',
  }

  -> exec { 'bundle install':
    command => '/usr/bin/env bundle install',
    cwd     => '/vagrant',
  }

  define run_cap_task {
    exec { "Running Capistrano task ${name}":
      command => "/usr/bin/env cap vagrant ${name}",
      cwd     => '/vagrant',
    }
  }

  run_cap_task { $capistrano_tasks: }
}
