`mkdir -p #{node[:extras][:home]}/releases #{node[:extras][:home]}/shared`
`chmod a+w #{node[:extras][:home]} #{node[:extras][:home]}/releases`

`su #{node['CHEF_USER']} -c 'mkdir $HOME/.ssh'`
`su #{node['CHEF_USER']} -c 'source /etc/profile ; echo PATH=$PATH > $HOME/.ssh/environment'`

if File.open('/etc/ssh/sshd_config').read !~ /PermitUserEnvironment/
  `echo PermitUserEnvironment yes >> /etc/ssh/sshd_config`
  `/etc/init.d/ssh restart`
end

