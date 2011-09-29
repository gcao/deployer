Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port "http", 80, 8000

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file lucid32.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "lucid32.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = %W"cookbooks my-cookbooks"
    chef.log_level = :debug

    chef.add_recipe "apt"
    chef.add_recipe "packages"
    chef.add_recipe "openssl"
    chef.add_recipe "cron"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::client"
    chef.add_recipe "php"
    chef.add_recipe "php::module_curl"
    chef.add_recipe "php::module_gd"
    chef.add_recipe "php::module_mysql"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_deflate"
    chef.add_recipe "apache2::mod_expires"
    chef.add_recipe "apache2::mod_headers"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_rewrite"
    chef.add_recipe "apache2::mod_proxy"
    chef.add_recipe "gems"
    chef.add_recipe "ucenter"
    chef.add_recipe "bbs"
    chef.add_recipe "jsgameviewer"
    chef.add_recipe "passenger_apache2"
    chef.add_recipe "gocool"

    # You may also specify custom JSON attributes:
    chef.json = {
      :bbs => {
        :docroot => "/data/apps/bbs/current",
        :home => "/data/apps/bbs"
      },
      :cronjobs => [
      ],
      :gems => [
        "rake",
        "mysql",
        "calendar_date_select",
        "thoughtbot-paperclip",
        "haml",
        "chriseppstein-compass",
        "mislav-will_paginate",
        "rspec",
        "SyslogLogger",
        "rubaidh-google_analytics",
        "binarylogic-searchlogic"
      ],
      :gocool => {
        :home => "/data/apps/gocool",
        :rails_env => "production",
        :rails_root => "/data/apps/gocool/current"
      },
      :jsgameviewer => {
        :docroot => "/data/apps/jsgameviewer/current",
        :home => "/data/apps/jsgameviewer"
      },
      :memcached => {
        :memory => 256
      },
      :mysql => {
        :server_root_password => "mysql_root_pw",
        :server_repl_password => "mysql_root_pw",
        :server_debian_password => "mysql_root_pw"
      },
      :packages => [
        "libreadline5-dev",
        "zlib1g-dev",
        "libssl-dev",
        "libxml2-dev",
        "libxslt1-dev",
        "sysklogd",
        "postfix",
        "unzip",
        "htop"
      ],
      :ucenter => {
        :docroot => "/data/apps/ucenter/current",
        :home => "/data/apps/ucenter"
      }
    }
  end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # IF you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
