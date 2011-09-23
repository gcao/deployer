`mkdir #{node[:ucenter][:home]}/releases`

web_app "ucenter" do
  docroot node[:ucenter][:docroot]
  template "ucenter.conf.erb"
end

# service "apache2" do
#   action :restart
# end