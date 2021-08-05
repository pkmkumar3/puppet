init.pp -->
class appx {
  contain appx::config_file
  contain appx::service
  }
  
  ---
  conifg_file
  
  class appx::config_file (
  String $mypackage,
  String $ensure,){
    package {'$mypackage':
      name => '$mypackage',
      ensure => $ensure,
      }
    file {'/etc/init.d/appX':
      ensure => present,
      content => 'puppet:///module/appx/files/abc.txt',
      }
      
    -----
    service.pp
    class appx::service (
    String $service,
    String $ensure,) {
      service {'$service':
        ensure => $ensure,
        enable => true,
        
       }
       
       data/common.yaml
       appx::config_file:mypackage: appx
       appx::config_file:ensure: 1.0
       appx::service::service: appx
       appx::service::ensure: on
