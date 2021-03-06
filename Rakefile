desc "Show tasks"
task :default do
  output = `rake -T`.lines.to_a
  output.shift # Remove first line in output
  puts output
end

REMOTE_CHEF_PATH = "/etc/chef" # Where to find upstream cookbooks

desc "Prepare server for ssh as root"
task :prepare do
  check_server_env :prepare
  sh "ssh #{ENV['CHEF_USER']}@#{ENV['CHEF_SERVER']} 'sudo cp /home/#{ENV['CHEF_USER']}/.ssh/authorized_keys /root/.ssh/'"
  sh "ssh root@#{ENV['CHEF_SERVER']} 'source /etc/profile ; echo PATH=$PATH > $HOME/.ssh/environment'"
  sh "ssh root@#{ENV['CHEF_SERVER']} 'echo PermitUserEnvironment yes >> /etc/ssh/sshd_config'"
  sh "ssh root@#{ENV['CHEF_SERVER']} restart ssh"
end

desc "Bootstrap server for chef"
task :bootstrap do
  check_server_env :bootstrap

  sh "scp bin/bootstrap root@#{ENV["CHEF_SERVER"]}:/tmp"
  sh "ssh root@#{ENV["CHEF_SERVER"]} /tmp/bootstrap"
end

desc "Test your cookbooks and config files for syntax errors"
task :test do
  Dir[ File.join(File.dirname(__FILE__), "*cookbooks", "**", "*.rb") ].each do |recipe|
    sh %{ruby -c #{recipe}} do |ok, res|
      raise "Syntax error in #{recipe}" if not ok
    end
  end
end

desc "Upload the latest copy of your cookbooks to remote server"
task :upload do
  check_server_env :upload

  puts "* Upload your cookbooks *"
  sh "export GENERATE_DNA_ONLY=true; vagrant"
  #sh "ssh root@#{ENV['CHEF_SERVER']} rm -rf #{REMOTE_CHEF_PATH}"
  sh "rsync -rlP --delete --exclude '.*' --exclude 'data/*' #{File.dirname(__FILE__)}/ root@#{ENV['CHEF_SERVER']}:#{REMOTE_CHEF_PATH}"
  #sh "rm dna.json"
end

desc "Run chef solo on the server"
task :cook do
  check_server_env :cook

  puts "* Running chef solo on remote server *"
  sh "ssh root@#{ENV['CHEF_SERVER']} /usr/local/rbenv/shims/chef-solo -l debug -c #{REMOTE_CHEF_PATH}/solo.rb -j #{REMOTE_CHEF_PATH}/dna.json"
end

namespace :maintenance do
  desc "Start maintenance"
  task :start do
    check_server_env :'maintenance:start'

    # TODO: .htaccess is not good, see http://httpd.apache.org/docs/current/howto/htaccess.html
    # Let's use a special config file instead
    my_public_ip = `curl http://www.biranchi.com/ip.php`
    `cat <<HTACCESS | ssh root@#{ENV['CHEF_SERVER']} 'cat > /var/www/.htaccess'
Options +FollowSymlinks
RewriteEngine on
RewriteCond %{REQUEST_URI} !/maintenance.html$
RewriteCond %{REMOTE_ADDR} !^#{my_public_ip.gsub('.', '\.')}
RewriteRule $ /maintenance.html [R=302,L]
HTACCESS
`
  end

  desc "Stop maintenance"
  task :stop do
    check_server_env :'maintenance:start'

    `ssh root@#{ENV['CHEF_SERVER']} rm /var/www/.htaccess`
  end
end

def check_server_env task
  if !ENV["CHEF_SERVER"]
    puts "CHEF_SERVER is not set!"
    exit 1
  end
end

desc "Create a new cookbook (with cookbook=name)"
task :new_cookbook do
  create_cookbook(File.join(File.dirname(__FILE__), "cookbooks"))
end

def create_cookbook(dir)
  raise "Must provide a COOKBOOK=" unless ENV["cookbook"]
  puts "** Creating cookbook #{ENV["cookbook"]}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "attributes")}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "recipes")}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "definitions")}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "libraries")}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "files", "default")}"
  sh "mkdir -p #{File.join(dir, ENV["cookbook"], "templates", "default")}"

  unless File.exists?(File.join(dir, ENV["cookbook"], "recipes", "default.rb"))
    open(File.join(dir, ENV["cookbook"], "recipes", "default.rb"), "w") do |file|
      file.puts <<-EOH
#
# Cookbook Name:: #{ENV["cookbook"]}
# Recipe:: default
#
EOH
    end
  end
end

