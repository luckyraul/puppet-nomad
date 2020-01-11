# == Class: nomad
class nomad (
  $version              = $nomad::params::version,
  $url_base             = $nomad::params::url_base,
  $service_url          = $nomad::params::service_url,
  $service_path         = $nomad::params::service_path,
  $config_defaults      = $nomad::params::config_defaults,
  $server               = false,
  $client               = false,
  $config_hash          = {},
  $config_dir           = $nomad::params::config_dir,
  $data_dir             = $nomad::params::data_dir,
  $pretty_config        = true,
  $pretty_config_indent = 4,
  $service_enable       = true,
  $service_ensure       = 'running',
) inherits nomad::params {

  if $server {
    $config_server_hash = $nomad::params::server_defaults
  } else {
    $config_server_hash = {}
  }

  if $client {
    $config_client_hash = $nomad::params::client_defaults
  } else {
    $config_client_hash = {}
  }

  $config_hash_real = deep_merge($config_defaults, $config_server_hash, $config_client_hash, $config_hash)

  validate_hash($config_hash_real)

  anchor {'nomad_first': } -> class { 'nomad::install': }
    -> class { 'nomad::config': config_hash => $config_hash_real }
    ~> class { 'nomad::service': }
}
