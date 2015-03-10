class mcommons {
  include mcommons::system
  include mcommons::mysql
  include mcommons::elasticsearch
  include mcommons::memcached
  include mcommons::nginx
  include mcommons::ruby
  include mcommons::ruby::gems
  include mcommons::ruby::unicorn
  include mcommons::ruby::db_migrate
  include mcommons::ruby::rails
}
