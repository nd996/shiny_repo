class shiny_server::install_shiny_server {
  # this is needed to install the shiny-server deb later
  include gdebi

  # $filepath = inline_template("<%= `curl -s https://posit.co/download/shiny-server/ | grep -iP 'wget https:\/\/download3\.rstudio\.org\/ubuntu-18\.04\/x86_64\/shiny-server-\d+(\.\d+)*-amd64\.deb' | sed -e 's/^[ \t(wget)]*//'` %>")
  # notify { "STDOUT: ${filepath}":}
  # $filepath = "https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.19.995-amd64.deb"

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
  
  # 1.
  # use the defined resource to install the shiny packages after r-base is installed
  # and before the shiny-server.deb is installed
  shiny_server::install_r_package { 
    'shiny':,
    require => Package['r-base'],
    before => Exec['install_latest_shiny_server'],
  }


  # # curl -s https://posit.co/download/shiny-server/ | grep -iP 'wget https:\/\/download3\.rstudio\.org\/ubuntu-18\.04\/x86_64\/shiny-server-\d+(\.\d+)*-amd64\.deb' | sed -e 's/^[ \t]*//'
  # exec {'download-latest-shiny-server.deb':
  #   #download deb
  #   unless # version matches installed deb
  # }

  # 2.
  # this deb is the only official one available for ubuntu, the page says its 16.04+ ...so should be good
  ## need to add a check here...
  # file {'latest-shiny-server.deb':
  #   ensure  => 'present',
  #   source  => 'https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.19.995-amd64.deb',
  #   # source  => $filepath,
  #   path    => '/root/shiny-server.deb',
  # }

  $url        = 'https://posit.co/download/shiny-server/'
  $pattern    = "https:\/\/download3\.rstudio\.org\/ubuntu-18\.04\/x86_64\/shiny-server-\d+(\.\d+)*-amd64\.deb | sed -e 's/^[ \t(wget)]*//'"
  $timeout      = 300
  $latest_version = inline_template("<%= `/usr/bin/curl -s https://posit.co/download/shiny-server/ | /usr/bin/grep -iP 'ubuntu-18\.04\/x86_64\/shiny-server-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-amd64\.deb' | /usr/bin/cut -d '-' -f 4` %>")
  notify{"The value of latest_version is: ${latest_version}": }
  notify{"The value of shiny_server_installed_version is: ${shiny_server_installed_version}": }
  $number_version = regsubst($latest_version, '\.', '')
  notify{"The value of number_version is: ${number_version}": }

  exec { "install_latest_shiny_server":
    command     => "/usr/bin/curl -s ${url} | /usr/bin/grep -iP '${patern}'",
    timeout     => $timeout,
    # only install the package if it's not already installed
    # unless      => "${r_path} -q -e \"'${name}' %in% installed.packages()\" | grep 'TRUE'",
    onlyif      => "/usr/bin/test ${latest_version} -gt ${shiny_server_installed_version}",
    require     => Package['r-base'],
  }

  # 3.
  package { 'shiny-server.deb':
    provider => gdebi,
    source   => '/root/shiny-server.deb',
    subscribe  => Exec['install_latest_shiny_server'],
  }

  # notify{$::shiny_server_deb_version:}
  # notify{$::shiny_server_installed_version:}

}
