`mkdir -p #{node[:ucenter][:home]}/releases #{node[:ucenter][:home]}/shared/config/data`
`chmod a+w #{node[:ucenter][:home]} #{node[:ucenter][:home]}/releases`

web_app "ucenter" do
  docroot node[:ucenter][:docroot]
  template "ucenter.conf.erb"
end

template "#{node[:ucenter][:home]}/shared/config/data/config.inc.php" do
  source "config.inc.php.erb"
  mode 0644
end

