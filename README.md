# Test in VMs to get R & Shiney installed via Puppet

05.12.22
- Code tidy up, removed unused class
- Ensured that when the shiny R package is first installed it installs all dependencies

---

02.12.22
- Added defined resource to install shiny apps!!
- Tidied the code up a little

---

01.12.22
- Made it more modular
- It now tests if the latest shiny-server.deb is installed and wont download, or re-install that deb if we have the latest
- Set a few custom facts to help out
- Renamed a a few things to be more intuitive

---

Basic working version, right now it adds the official R repo, installs the latest version of R, installs the shiny R package then installs Shiny server, one extra R package. The R packages can be installed through the r_packages.pp simply by adding a small code block. Shiny apps can now be installed from the shiny_apps.pp file, only basic support exists for now. This needs to include options like private git repo, if storage is needed and user authentication.

To Do
- Orgainse the files and folders including better naming **in progress**
- Test Shiny deb is installed before installing again, right now it installs every time  **in progress**
- No work on adding new apps has been started yet **in progress**
    - Pull from git repo (only)
    - User auth
    - Private git repo
    - Storage if needed
- Eventually this should be a complete module we submit to Puppet Forge
- Probably need to customise settings, for the web server, logs etc
- Installing a r package with dependencies on a new shiny server can timeout, just rerun `puppet agant -t` to fix
- More stuff I'm sure...

---

The Vagrant file I used to create the two VMs is below, note that Puppet server only supports Ubuntu 18.04 unless you compile by source. Once created and you get Puppet working the repo should then work as described with no manual config:

# Vagrant
    CPUS="1"
    MEMORY="2048"

    Vagrant.configure("2") do |config|
    config.vm.define "master" do |vm1|
        vm1.vm.box = "ubuntu/focal64" 
        vm1.vm.hostname = "puppetmaster.vm"
        vm1.vm.network :private_network, ip: "192.168.56.2"
        
        vm1.vm.provider "virtualbox" do |vb|
        vb.name = "puppetmaster.vm"
        vb.memory = MEMORY
        vb.cpus = CPUS
        end
    end

    config.vm.define "shiny" do |vm2|
        vm2.vm.box = "generic/ubuntu2204"
        vm2.vm.hostname = "shinyserver.vm"
        vm2.vm.network :private_network, ip: "192.168.56.3"
        vm2.vm.network "forwarded_port", guest: 3838, host: 3838
        vm2.vm.provider "virtualbox" do |vb|
        vb.name = "shinyserver.vm"
        vb.memory = MEMORY
        vb.cpus = CPUS
        end
    end

    end
