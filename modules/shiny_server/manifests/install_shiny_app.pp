define shiny_server::install_shiny_app (
  $path     = '/srv/shiny-server/',
  $repo         = '',
  $private_key  = '',
  $storage      = false,
  $auth         = false,
  ) {

    file { "create_app_dir_${name}":
      ensure  => directory,
      path    => "${path}${name}",
    }

    vcsrepo { "${path}${name}":
      ensure   => present,
      provider => git,
      source   => $repo,

    }

}

