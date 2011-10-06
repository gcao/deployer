include_recipe "rails"

`mkdir -p #{node[:gocool][:home]}/releases #{node[:gocool][:home]}/shared/config/initializers #{node[:gocool][:home]}/shared/bundle`
`chmod a+w #{node[:gocool][:home]} #{node[:gocool][:home]}/releases #{node[:gocool][:home]}/shared/bundle`

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

template "#{node[:gocool][:home]}/shared/config/database.yml" do
  source "database.yml.erb"
  mode 0644
  variables(
    :username => 'root',
    :password => node[:mysql][:server_root_password]
  )
end

`echo '<html><head><meta HTTP-EQUIV="REFRESH" content="0; url=http://#{node[:server_name]}/bbs/index.php"></head><body>Redirecting...</body></html>' > /var/www/index.html`

`ln -s #{node[:gocool][:rails_root]}/public /var/www/app`

web_app "gocool" do
  template "gocool.conf.erb"
  docroot node[:gocool][:rails_root] + "/public"
  server_name node[:fqdn]
  rails_env node[:gocool][:rails_env]
end

puts "===================== disable default site ====================="
`rm /etc/apache2/sites-enabled/000-default`

service "apache2" do
  action :restart
end

