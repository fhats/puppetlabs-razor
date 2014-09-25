class razor::server(
  $package_ensure = 'latest',
) {
  $url  = 'http://links.puppetlabs.com/razor-server-latest.zip'
  $dest = '/opt/razor'

  package { "razor-server":
    ensure   => $package_ensure,
    require  => [Package[curl], Package[unzip]],
    notify   => Exec["deploy razor to torquebox"]
  }

  exec { "deploy razor if it was undeployed":
    provider => shell,
    unless   => "test -f ${razor::torquebox::dest}/jboss/standalone/deployments/razor-knob.yml",
    # This is actually "notify if the file does not exist" :)
    command  => ":",
    notify   => Exec["deploy razor to torquebox"],
    require  => Package['razor-server']
  }

  # deploy razor, if required.
  exec { "deploy razor to torquebox":
    command     => "${razor::torquebox::dest}/jruby/bin/torquebox deploy --env production",
    cwd         => $dest,
    environment => [
      "TORQUEBOX_HOME=${razor::torquebox::dest}",
      "JBOSS_HOME=${razor::torquebox::dest}/jboss",
      "JRUBY_HOME=${razor::torquebox::dest}/jruby"
    ],
    path        => "${razor::torquebox::dest}/jruby/bin:/bin:/usr/bin:/usr/local/bin",
    require     => Package['razor-server'],
    refreshonly => true
  }

  file { "${dest}/bin/razor-binary-wrapper":
    ensure  => file, owner => root, group => root, mode => 0755,
    content => template('razor/razor-binary-wrapper.erb'),
    require => Package['razor-server']
  }

  file { "/usr/local/bin/razor-admin":
    ensure => link, target => "${dest}/bin/razor-binary-wrapper"
  }

  # Work around what seems very much like a bug in the package...
  file { "${dest}/bin/razor-admin":
    mode    => 0755,
    require => Package['razor-server']
  }

  file { "/var/lib/razor":
    ensure => directory, owner => razor-server, group => razor-server, mode => 0775,
    require => Package['razor-server']
  }

  file { "/var/lib/razor/repo-store":
    ensure => directory, owner => razor-server, group => razor-server, mode => 0775
  }

  file { "${dest}/log":
    ensure  => directory, owner => razor-server, group => razor-server, mode => 0775,
    require => Package['razor-server']
  }

  file { "${dest}/log/production.log":
    ensure  => file, owner => razor-server, group => razor-server, mode => 0660
  }
}
