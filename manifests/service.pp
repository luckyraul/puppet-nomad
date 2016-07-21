# == Class nomad::service
#
# This class is meant to be called from nomad
# It ensure the service is running
#
class nomad::service {
  service { 'nomad':
      ensure => $nomad::service_ensure,
      enable => $nomad::service_enable,
  }
}
