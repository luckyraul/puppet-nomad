# == Class nomad::install
class nomad::config (
  $config_hash,
){

  file { $nomad::config_dir:
    ensure => 'directory'
  } -> file { 'nomad config.json':
    ensure  => present,
    path    => "${nomad::config_dir}/config.json",
    content => nomad::sorted_json($config_hash, $nomad::pretty_config, $nomad::pretty_config_indent),
  }
}
