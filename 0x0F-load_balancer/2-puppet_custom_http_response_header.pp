# creating a custom HTTP header response with Puppet

exec { 'update':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
    ensure   => installed,
    require => exec['update'],
}

file_line { 'redirect':
  ensure  => 'present',
  path    => '/etc/nginx/sites-available/default',
  after   => 'listen 80 default_server;',
  line    => 'rewrite ^/redirect_me https://www.youtube.com/watch?v=dQw4w9WgXcQ permanent;',
  require => Package['nginx'],
}

file_line { 'addHeader':
  ensure  => 'present',
  path    => '/etc/nginx/sites-available/default',
  after   => 'listen 80 default_server;',
  line    => 'add_header X-Served-By $hostname;',
  require => Package['nginx'],
}

file { '/var/www/html/index.html':
  content => 'Holberton School',
  require => Package['nginx'],
}

service { 'nginx':
  ensure  => running,
  require => Package['nginx'],
}