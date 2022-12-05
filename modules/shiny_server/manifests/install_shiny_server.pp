class shiny_server::install_shiny_server {
  # this is needed to install the shiny-server deb later
  include gdebi

  $timeout = 300
  $latest_version = inline_template("<%= `/usr/bin/curl -s https://posit.co/download/shiny-server/ | /usr/bin/grep -iP 'ubuntu-18\.04\/x86_64\/shiny-server-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-amd64\.deb' | /usr/bin/cut -d '-' -f 4 | tr -d '\n'` %>")
  $deb_url = inline_template("<%= `/usr/bin/curl -s https://posit.co/download/shiny-server/ | /usr/bin/grep -iP 'ubuntu-18\.04\/x86_64\/shiny-server-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-amd64\.deb' | /usr/bin/sed 's/^[ \t(wget)]*//' | tr -d '\n'` %>")
  
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

  # 1.
  package { 'r-base':
    ensure  => 'installed',
    require => Apt::Source['cran'],
  }
  
  # 2.
  # use the defined resource to install the shiny packages after r-base is installed
  # and before the shiny-server.deb is installed
  shiny_server::install_r_package { 
    'shiny': dependencies => true,
    require => Package['r-base'],
    before  => Exec['download_latest_shiny_server'],
  }

  # 3.
  exec { "download_latest_shiny_server":
    command   => "/usr/bin/wget ${deb_url} -O /home/vagrant/shiny-server.deb",
    timeout   => $timeout,
    # only download the package if the latest version online is greater then the installed one
    onlyif    => "/usr/bin/dpkg --compare-versions ${latest_version} gt ${shiny_server_installed_version}",
    require   => Package['r-base'],
  } 

  # 4. Using exec as don't want this to run every puppet update, which it was when using package and gdebi
  exec { 'install_shiny-server.deb':
    command   => '/usr/bin/gdebi -n /home/vagrant/shiny-server.deb',
    # only install the package if the latest version online is greater then the installed one
    onlyif    => "/usr/bin/dpkg --compare-versions ${latest_version} gt ${shiny_server_installed_version}",
    require   => Exec['download_latest_shiny_server'],
  }
}
