class profile::shiny {
  # this is needed to install the shiny-server deb later
  include gdebi

  apt::source { 'cran':
    ensure => 'present',
    location => 'https://cloud.r-project.org/bin/linux/ubuntu',
    repos    => '',
    release  => 'jammy-cran40/',
    key      => {
      id     => 'E298A3A825C0D65DFD57CBB651716619E084DAB9',
      source => 'https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc',
    },
  }

  package { 'r-base':
    ensure => 'installed',
    require => Apt::Source['cran'],
  }
  
  # not needed as the include at the top will atomatically do this
  # package { 'gdebi-core': 
  #   ensure => 'installed',
  # }

  exec { 'install_shiny_package':
    command => "/usr/bin/R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\"",
    creates => '/usr/local/lib/R/site-library/shiny',
    require => Package['r-base'],
  }

  # this deb is the only official one available for ubuntu, the page says its 16.04+ ...so should be good
  file {'shiny-server.deb':
    ensure  => 'present',
    source  => 'https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.19.995-amd64.deb',
    path    => '/root/shiny-server-1.5.19.995-amd64.deb',
    require => Exec['install_shiny_package'],
  }

  package { 'shiny-server-1.5.19.995-amd64.deb':
    provider => gdebi,
    source   => '/root/shiny-server-1.5.19.995-amd64.deb',
    require  => File['shiny-server.deb'],
  }

}
