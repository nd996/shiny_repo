class shiny_server::install_latest_shiny_server (
  $url        = 'https://posit.co/download/shiny-server/',
  $pattern    = "https:\/\/download3\.rstudio\.org\/ubuntu-18\.04\/x86_64\/shiny-server-\d+(\.\d+)*-amd64\.deb | sed -e 's/^[ \t(wget)]*//'",
  # $dependencies = false,
  $timeout      = 300,
  ) {

    # $command = $dependencies ? {
    #   true    => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = TRUE)\"",
    #   default => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = FALSE)\""
    # }

    exec { "install_latest_shiny_server":
      command     => "curl -s ${url} | grep -iP '${patern}'",
      timeout     => $timeout,
      # only install the package if it's not already installed
      # unless      => "${r_path} -q -e \"'${name}' %in% installed.packages()\" | grep 'TRUE'",
      onlyif      => $shiny_server_deb_version > $shiny_server_installed_version,
      require     => Package['r-base'],
    }
  

}
