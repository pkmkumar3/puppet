case $facts ['os'] ['family'] {
  'RedHat':
     case $facts ['os'] ['release'] ['major'] {
       '6':
     package {'ntp':
       name   => 'ntp',
       ensure => installed,
       }
     file {'/etc/sysconfig/ntpd':
       ensure  => present
       content => 'OPTIONS="-u ntpd"',
     }
     service {'ntpd'
      ensure => running,
      enable => true,
      }
     }
       '7':
     package {'chrony':
       name   => 'chrony',
       ensure => installed,
     file {'/etc/sysconfig/chronyd':,
       ensure  => present,
       content => 'OPTIONS="-u chrony"',
       }
     service {'chronyd:'
      ensure => running,
      enable => true, 
      }
     }
    }
