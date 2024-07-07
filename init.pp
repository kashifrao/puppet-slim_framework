# == Class: slim_framework
#
# Installs and configures 
# 
# === Copyright
# All Rights Reserved.
#

 
class slim_framework (
$vhosts=lookup('vhosts'),
)

{
  
  
  $vhosts.each  |$vhost, $params| {
  
  
  # ----------------------------------------------------------------------------
  # Install Setup Slim Framework
  # ----------------------------------------------------------------------------
  
  
  exec { "Download composer for ${vhost} ":
    command => "/usr/bin/wget https://getcomposer.org/composer.phar",
    cwd     => "/var/www/html/${vhost}/",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    onlyif  => "test ! -f /var/www/html/${vhost}/composer.phar",
    user    => 'apache',
    group   => 'apache',
    require => Class['apache'],
  }
  ->
  exec { "Install Slim for ${vhost}":
    command => '/usr/bin/php composer.phar require slim/slim "^3.0";/usr/bin/php composer.phar require slim/twig-view; /usr/bin/php composer.phar require slim/php-view; ',
    cwd     => "/var/www/html/${vhost}/",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    #onlyif  => "test ! -f /var/www/html/${vhost}/vendor/autoload.php",
    environment => ["COMPOSER_HOME=/var/www/html/${vhost}/"],
    user    => 'apache',
    group   => 'apache',
  }
  ->
  file { "/var/www/html/${vhost}/composer.json":
    ensure => "present",
    content => template('bundle/project/composer.json.erb'),
    owner => "apache",
    group => "apache",
    mode    => '0755'
  }
  ->
  exec { "psr-4 autloading for ${vhost}":
    command => '/usr/bin/php composer.phar dump-autoload -o;',
    cwd     => "/var/www/html/${vhost}/",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    environment => ["COMPOSER_HOME=/var/www/html/${vhost}/"],
  }
  
 }
 

# ----------------------------------------------------------------------------
# Add any additional settings *above* this comment block.
# ----------------------------------------------------------------------------

}