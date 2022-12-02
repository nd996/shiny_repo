class shiny_server::shiny_apps {
  # put list of R packages to install for shiny apps
  # syntx is: 
  #       profile::install_package {
  #          '<package_Name>': dependencies => true,  # optional, default is FALSE 
  #       }
  shiny_server::install_shiny_app { 
    'test': repo => 'https://github.com/yhejazi/tutorials.git',
  }

}



