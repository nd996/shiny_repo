class profile::r_packages {
  # put list of R packages to install for shiny apps
  # syntx is: 
  #       profile::install_package {
  #          '<package_Name>': dependencies => true,  # optional, default is FALSE 
  #       }
  profile::install_package { 
    'rmarkdown':,
  }

}



