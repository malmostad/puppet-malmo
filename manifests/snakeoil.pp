class mcommons::snakeoil() {
  require ::mcommons

  exec { 'generate-self-signed-ssl-certs':
    command => "/usr/bin/openssl req -batch -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/${::fqdn}-snakeoil.key -out /etc/ssl/certs/${::fqdn}-snakeoil.crt"
  }
}
