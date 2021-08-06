init.pp -->
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include tanium
class tanium (
  $taniumservice = $tanium::params::taniumservice,
  $package_version = undef,
)
inherits tanium::params
{
  file { 'TaniumDir':
    ensure => directory,
    path   => '/opt/Tanium/',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'TaniumClientDir':
    ensure  => directory,
    path    => '/opt/Tanium/TaniumClient/',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['TaniumDir'],
  }
  
  if $package_version != undef {
    file { 'Downloading DAT file':
      ensure  => file,
      source  => 'puppet:///modules/tanium/tanium-init.dat',
      path    => '/opt/Tanium/TaniumClient/tanium-init.dat',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['TaniumDir'],
    }

    package { 'TaniumClient':
        name    => 'TaniumClient',
        ensure  => installed,
        require => File['Downloading DAT file'],
    }

    exec { 'taniumconf':
        command     => '/opt/Tanium/TaniumClient/TaniumClient config set ServerName tanclient1.cummins.com,tanclient2.cummins.com',
        require     => File['Downloading DAT file'],
        notify      => Service[$taniumservice],
        subscribe   => Package['TaniumClient'],
        refreshonly => true,
      }

    service {$taniumservice :
        name    => $taniumservice,
        enable  => true,
        ensure  => running,
        require => [
          Package['TaniumClient'],
          File['Downloading DAT file']
        ],
      }
  }
  else {
    file { 'pub':
      ensure  => file,
      source  => 'puppet:///modules/tanium/tanium.pub',
      path    => '/opt/Tanium/TaniumClient/tanium.pub',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['TaniumDir'],
    }
    package { 'TaniumClient':
      name    => 'TaniumClient',
      ensure  => installed,
      require => File['pub'],
    }
    exec { 'taniumconf':
      command     => '/opt/Tanium/TaniumClient/TaniumClient config set ServerName tanclient1.cummins.com,tanclient2.cummins.com',
      require     => File['pub'],
      notify      => Service[$taniumservice],
      subscribe   => Package['TaniumClient'],
      refreshonly => true,
    }
    service { taniumservice :
      name    => $taniumservice,
      enable  => true,
      ensure  => running,
      require => [
        Package['TaniumClient'],
        File['pub']
      ],
    }
  }
}

==================================

pramas.pp -->

# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include tanium::params
class tanium::params {
  if $facts['os']['name'] == 'Redhat' {
    if $facts['os']['release']['major'] == '7' {
      $taniumservice = 'taniumclient'
    }
    elsif $facts['os']['release']['major'] == '8' {
      $taniumservice = 'taniumclient'
    }
    elsif $facts['os']['release']['major'] == '6' {
      $taniumservice = 'TaniumClient'
    }
    elsif $facts['os']['release']['major'] == '5' {
      $taniumservice = 'taniumclient'
    }
  }
  elsif $facts['os']['name'] == 'OracleLinux' {
    if $facts['os']['release']['major'] == '7' {
      $taniumservice = 'taniumclient'
    }
    elsif $facts['os']['release']['major'] == '6' {
      $taniumservice = 'TaniumClient'

    }
    elsif $facts['os']['release']['major'] == '5' {
      $taniumservice = 'taniumclient'
    }
  }
  else {
    notify {'taniumerror' : message => 'OS not supported', }
  }
}

===========================================
