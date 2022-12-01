Facter.add('shiny_server_latest') do
  setcode do
    Facter::Core::Execution.execute("/usr/bin/curl -s https://posit.co/download/shiny-server/ | /usr/bin/grep -iP 'ubuntu-18\.04\/x86_64\/shiny-server-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-amd64\.deb' | /usr/bin/cut -d '-' -f 4")
  end
end
