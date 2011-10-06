`mkdir -p #{node[:bbs][:home]}/releases #{node[:bbs][:home]}/shared/config`
`chmod a+w #{node[:bbs][:home]} #{node[:bbs][:home]}/releases`

web_app "bbs" do
  docroot node[:bbs][:docroot]
  template "bbs.conf.erb"
end

template "#{node[:bbs][:home]}/shared/config/config.inc.php" do
  source "config.inc.php.erb"
  mode 0644
end

