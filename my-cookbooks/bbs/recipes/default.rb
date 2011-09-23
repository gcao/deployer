`mkdir #{node[:bbs][:home]}/releases`

web_app "bbs" do
  docroot node[:bbs][:docroot]
  template "bbs.conf.erb"
end

# service "apache2" do
#   action :restart
# end