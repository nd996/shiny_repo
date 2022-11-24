node default {
  
}

node 'puppetmaster.vm' {
  include role::master_server
  file { '/root/README':
    ensure => file,
    content => "Welcome to ${fqdn}\n",
  }
}

node 'shinyserver.vm' {
  include role::shiny_server
}
