# == Class nomad::install
class nomad::install {

  staging::deploy { "nomad-${nomad::version}.zip":
    source  => "${nomad::url_base}${nomad::version}/nomad_${nomad::version}_linux_${::architecture}.zip",
    target  => '/usr/bin/',
    creates => '/usr/bin/nomad',
  } ->
  staging::file { 'nomad-systemd.service':
    source => $nomad::service_url,
    target => $nomad::service_path,
  } ~>
  exec { 'nomad-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

}
