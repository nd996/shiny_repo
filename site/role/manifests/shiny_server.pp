class role::shiny_server {
  include profile::base
  include shiny_server::install_shiny_server
  include shiny_server::r_packages
}
