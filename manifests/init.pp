# == Class: remaster
#
# This will manage the server configuration of your puppet node allowing you
# to move your node from one master to another.
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib and puppetlabs/inifile modules on
# the Puppet Forge in order to validate much of the the provided configuration.
#
# === Parameters
#
# [*puppetmaster*]
# The fqdn of the master that you want your nodes to point to.
#
# === Examples
#
# Assign a node to a particular master:
#
#  remaster { 'puppetmaster':
#    puppetmaster => 'puppetmaster.corp.company.com'
#  }
#
class remaster (
  $puppetmaster = $::servername
) {

  validate_re($::agent_ssldir, '.+', 'agent_ssldir custom fact does not validate.')
  validate_re($::agent_config, '.+', 'agent_config custom fact does not validate.')
  validate_absolute_path($::agent_ssldir)
  validate_absolute_path($::agent_config)

  if downcase($::servername) != downcase($puppetmaster) {
    ini_setting { 'update_main_server':
      ensure  => present,
      section => 'main',
      setting => 'server',
      value   => $puppetmaster,
      path    => $::agent_config,
      notify  => Service['puppet'],
    } ->

    ini_setting { 'update_main_ca_server':
      ensure  => present,
      section => 'main',
      setting => 'ca_server',
      value   => $puppetmaster,
      path    => $::agent_config,
    } ->

    ini_setting { 'remove_agent_server':
      ensure  => absent,
      section => 'agent',
      setting => 'server',
      path    => $::agent_config,
    } ->

    ini_setting { 'remove_agent_ca_server':
      ensure  => absent,
      section => 'agent',
      setting => 'ca_server',
      path    => $::agent_config,
    } ->

    file { $::agent_ssldir:
      ensure => absent,
      force  => true,
    }
  }

  class { 'remaster::service': } ->
  Class['remaster']
}
