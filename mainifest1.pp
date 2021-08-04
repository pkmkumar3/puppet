class apache {

package {'httpd package':
  name   => 'httpd',
  ensure => installed,
  
} 

 $http.conf = '<IfModule prefork.c>
               StartServers        4
               MinSpareServers     20
               MaxSpareServers     40
               MaxClients          200
               MaxRequestsPerChild 4500
               </IfModule>'
file { '/etc/httpd/conf/httpd.conf':
  ensure  => present,
  content => $http.conf,
}

$vhost = '<VirtualHost *:80>
             ServerAdmin admin@example.org
             ServerName example.org
             ServerAlias www.example.org
             DocumentRoot /srv/www/example.org/public_html/
             ErrorLog /srv/www/example.org/logs/error.log
             CustomLog /srv/www/example.org/logs/access.log combined
        </VirtualHost>'

file {'/etc/httpd/conf.d/vhost.conf':
  ensure  => present,
  content => $vhost,
}

file {'/srv/www/example.org/public_html':
  ensure  => directory,
  recurse => true,
}

file {'/srv/www/example.org/logs':
  ensure  => directory,
  recurse => true,
}

service {'httpd':
  ensure => running,
  enable => true,
}
package {'mod packages':
  name   => ['mod_perl', 'mod_wsgi', 'php-pear'],
  ensure => installed,
}
