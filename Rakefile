desc "Show tasks"
task :default do
  output = `rake -T`.lines.to_a
  output.shift # Remove first line in output
  puts output
end

REMOTE_CHEF_PATH = "/tmp/chef" # Where to find upstream cookbooks

desc "Bootstrap server for chef"
task :bootstrap do
  check_server_env :bootstrap

  `scp bin/bootstrap #{ENV["server"]}:/tmp`
  `ssh #{ENV["server"]} sudo /tmp/bootstrap`
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
  sh "rsync -rlP --delete --exclude '.*' --exclude 'data/*' #{File.dirname(__FILE__)}/ #{ENV['server']}:#{REMOTE_CHEF_PATH}"
  #sh "rm dna.json"
end

desc "Run chef solo on the server"
task :cook => [:upload]  do
  check_server_env :cook

  puts "* Running chef solo on remote server *"
  sh "ssh #{ENV['server']} \"cd #{REMOTE_CHEF_PATH}; chef-solo -l debug -c solo.rb -j dna.json \""
end

def check_server_env task
  if !ENV["server"]
    puts "You need to specify a server: rake #{task} server=whatever.com"
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

