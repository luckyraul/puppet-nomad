# == Class nomad::params
#
# This class is meant to be called from nomad
# It sets variables according to platform
#
class nomad::params {
  $version  = '0.12.0'
  $url_base = 'https://releases.hashicorp.com/nomad/'

  $service_url  = 'https://raw.githubusercontent.com/hashicorp/nomad/master/dist/systemd/nomad.service'
  $service_path = '/etc/systemd/system/nomad.service'

  $config_dir = '/etc/nomad.d'
  $data_dir = '/var/lib/nomad'
  $config_defaults = {
    data_dir => $data_dir
  }

  $server_defaults = {
    bind_addr => '0.0.0.0',
    advertise => {
      rpc => "${::ipaddress}:4647"
    },
    server => {
      enabled => true,
      bootstrap_expect => 1,
    }
  }

  $client_defaults = {
    bind_addr => '127.0.0.1',
    client => {
      enabled => true
    }
  }
}
