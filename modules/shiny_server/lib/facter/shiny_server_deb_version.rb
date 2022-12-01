Facter.add('shiny_server_deb_version') do
  setcode do
    Facter::Core::Execution.execute('/usr/bin/dpkg -f /root/shiny-server.deb Version')
  end
end
