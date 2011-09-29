include_recipe "rails"

## See http://seattlerb.rubyforge.org/SyslogLogger/
#syslog_updated = false
#File.open("/etc/syslog.conf").each do |line|
#  syslog_updated = true and break if line.include?('gocool.log')
#end
#unless syslog_updated
#  `echo >> /etc/syslog.conf`
#  `echo '!rails' >> /etc/syslog.conf`
#  `echo '*.*  /var/log/gocool.log' >> /etc/syslog.conf`
#  `touch /var/log/gocool.log`
#end

# Mysql setup
# -----------
template "/tmp/empty-gocool-db.sql" do
  owner 'root'
  group 'root'
  mode 0644
  source "empty-db.sql.erb"
end

`mkdir #{node[:gocool][:home]}/releases`
shared_config_dir = node[:gocool][:home] + "/shared/config"
`mkdir -p #{shared_config_dir}`

template shared_config_dir + "/database.yml" do
  source "database.yml.erb"
  mode 0644
  variables(
    :username => 'root',
    :password => node[:mysql][:server_root_password]
  )
end

execute "create-empty-db-for-gocool" do
  command "mysql -u root -p#{node[:mysql][:server_root_password]} < /tmp/empty-gocool-db.sql"
end

# puts "===================== disable default site ====================="
# `rm /etc/apache2/sites-enabled/000-default`

`echo '<html><head><meta HTTP-EQUIV="REFRESH" content="0; url=http://www.go-cool.org/bbs/index.php"></head><body>Redirecting...</body></html>' > /var/www/index.html`

`ln -s #{node[:gocool][:rails_root]}/public /var/www/app`

web_app "gocool" do
  template "gocool.conf.erb"
  docroot node[:gocool][:rails_root] + "/public"
  server_name node[:fqdn]
  rails_env node[:gocool][:rails_env]
end

service "apache2" do
  action :restart
end
