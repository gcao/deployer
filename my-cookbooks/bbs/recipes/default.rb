`mkdir -p #{node[:bbs][:home]}/releases #{node[:bbs][:home]}/shared/config`
`chmod a+w #{node[:bbs][:home]} #{node[:bbs][:home]}/releases`

web_app "bbs" do
  docroot node[:bbs][:docroot]
  template "bbs.conf.erb"
end

template "/etc/apache2/sites-available/bbs-maintenance.conf" do
  source "bbs-maintenance.conf.erb"
  mode 0644
end

template "/var/www/maintain-bbs.php" do
  source "maintain-bbs.php.erb"
  mode 0644
end

template "#{node[:bbs][:home]}/shared/config/config.inc.php" do
  source "config.inc.php.erb"
  mode 0644
end

