`mkdir -p #{node[:extras][:home]}/releases #{node[:extras][:home]}/shared`
`chmod a+w #{node[:extras][:home]} #{node[:extras][:home]}/releases`

`su #{node['CHEF_USER']} -c 'mkdir $HOME/.ssh'`
`su #{node['CHEF_USER']} -c 'source /etc/profile ; echo PATH=$PATH > $HOME/.ssh/environment'`

if File.open('/etc/ssh/sshd_config').read !~ /PermitUserEnvironment/
  `echo PermitUserEnvironment yes >> /etc/ssh/sshd_config`
  `restart ssh`
end

File.open("/etc/profile.d/custom_environment.sh", "w") do |file|
  node.each do |key, value|
    next if key.to_s !~ /^CHEF/
    file.print "export #{key}='#{value}'\n"
  end
end

template "/var/www/index.php" do
  source "index.php.erb"
  mode 0644
end

