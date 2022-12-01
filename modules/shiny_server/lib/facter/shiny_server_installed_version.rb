Facter.add('shiny_server_installed_version') do
  setcode do
    Facter::Core::Execution.execute("/usr/bin/dpkg -l shiny-server | /usr/bin/grep shiny-server | tr -s ' ' | /usr/bin/cut -d ' ' -f 3")
  end
end
