include_recipe "rails"

# Fix ruby script by rbenv
`sed -i.bak 's|exec rbenv|exec $RBENV_ROOT/bin/rbenv|' /usr/local/rbenv/shims/ruby`

`mkdir -p #{node[:gocool][:home]}/releases #{node[:gocool][:home]}/shared/config/initializers #{node[:gocool][:home]}/shared/bundle`
`chmod a+w #{node[:gocool][:home]} #{node[:gocool][:home]}/releases #{node[:gocool][:home]}/shared/bundle`

# See http://seattlerb.rubyforge.org/SyslogLogger/
syslog_updated = false
File.open("/etc/syslog.conf").each do |line|
  syslog_updated = true and break if line.include?('gocool.log')
end
unless syslog_updated
  `echo '!gocool' >> /etc/syslog.conf`
  `echo 'user.*  /var/log/gocool.log' >> /etc/syslog.conf`
  `touch /var/log/gocool.log`
end

template "#{node[:gocool][:home]}/shared/config/database.yml" do
  source "database.yml.erb"
  mode 0644
  variables(
    :username => 'root',
    :password => node[:mysql][:server_root_password]
  )
end

template "#{node[:gocool][:home]}/shared/config/initializers/1_settings.rb" do
  source "1_settings.rb.erb"
  mode 0644
end

`ln -s #{node[:gocool][:rails_root]}/public /var/www/app`

web_app "gocool" do
  template "gocool.conf.erb"
  docroot node[:gocool][:rails_root] + "/public"
  server_name node[:CHEF_SERVER]
  rails_env node[:gocool][:rails_env]
end

template "/etc/apache2/sites-available/gocool-maintenance.conf" do
  source "gocool-maintenance.conf.erb"
  mode 0644
end

template "/var/www/maintain-app.php" do
  source "maintain-app.php.erb"
  mode 0644
end

puts "===================== disable default site ====================="
`rm /etc/apache2/sites-enabled/000-default`

service "apache2" do
  action :restart
end

