Facter.add('shiny_server_installed_version') do
  setcode do
    # this fact set to 0 if the shiny-server package is not installed, for the version check later
    is_installed = Facter::Core::Execution.execute('/usr/bin/dpkg -l shiny-server 2>&1') #.nil? && $?.success?
    if is_installed != 'dpkg-query: no packages found matching shiny-server'
      answer = Facter::Core::Execution.execute("/usr/bin/dpkg -l shiny-server | /usr/bin/grep shiny-server | tr -s ' ' | /usr/bin/cut -d ' ' -f 3")
    else
      answer = 0
    end
  end
end
