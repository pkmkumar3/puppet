init.pp -->
class appx {
  contain appx::config_file
  contain appx::service
  }
  
  ---
  module/appx/files/abc.txt
  "Single manifested static module without files/templates
Single manifested static module with files
Single manifested static module with templates *****************
Many manifested static module"
----------
  conifg_file
  
  class appx::config_file (
    String $mypackage,
    String $ensure1,
  ) {
    package {'$mypackage':
      name => $mypackage,
      ensure => $ensure1,
      }
    file {'/etc/init.d/appX':
      ensure => present,
      content => 'puppet:///module/appx/abc.txt',
      }
      
    -----
    service.pp
    class appx::service (
      String $service1,
      String $ensure2,
    ) {
      service {'$service':
        ensure => $ensure2,
        enable => true,
        
       }
       
       data/common.yaml
       appx::config_file:mypackage: appx
       appx::config_file:ensure1: 1.0
       appx::service::service1: appx
       appx::service::ensure2: on
