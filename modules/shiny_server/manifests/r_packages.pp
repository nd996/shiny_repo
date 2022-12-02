class shiny_server::r_packages {
  # put list of R packages to install for shiny apps
  # syntx is: 
  #       profile::install_package {
  #          '<package_Name>': dependencies => true,  # optional, default is FALSE 
  #       }
  shiny_server::install_r_package { 
    'rmarkdown':,
  }
  shiny_server::install_r_package { 
    'ggplot2': dependencies => true,
  }

}



