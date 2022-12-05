define shiny_server::install_r_package (
  $r_path       = '/usr/bin/R',
  $repo         = 'http://cran.rstudio.com',
  $dependencies = false,
  $timeout      = 500,
  ) {

    $command = $dependencies ? {
      true    => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = TRUE)\"",
      default => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = FALSE)\""
    }

    exec { "install_r_package_${name}":
      command     => $command,
      timeout     => $timeout,
      # only install the package if it's not already installed
      unless      => "${r_path} -q -e \"'${name}' %in% installed.packages()\" | grep 'TRUE'",
      require     => Package['r-base'],
    }
  
  # basic functionality for testing below
  # exec {"install_r_package_${name}":
  # command => "/usr/bin/R -e \"install.packages('${name}', repos='http://cran.rstudio.com/')\"",
  # }

}

