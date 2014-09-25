class razor::torquebox {
  $user = 'razor-server'
  $dest = '/opt/razor-torquebox'  # Must be the same as in the packaging

  package { "torquebox":
    ensure => latest
  } ->

  # Install an init script for the Razor torquebox install
  file { "/etc/init.d/razor-server":
    owner   => root, group => root, mode => 0755,
    content => template('razor/razor-server.init.erb')
  } ->

  file { "/var/log/razor-server":
    ensure => directory, owner => $user, group => 'root', mode => 0755
  } ->

  file { "/opt/razor-torquebox/jboss/standalone":
    ensure  => directory, owner => $user, group => $user,
    recurse => true, checksum => none,
    require => Package[torquebox],
  } ->

  service { "razor-server":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true
  }
}
