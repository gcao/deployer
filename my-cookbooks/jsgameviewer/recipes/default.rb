`mkdir #{node[:jsgameviewer][:home]}/releases`
shared_config_dir = node[:jsgameviewer][:home] + "/shared/config"
`mkdir -p #{shared_config_dir}`

web_app "jsgameviewer" do
  docroot node[:jsgameviewer][:docroot]
  template "jsgameviewer.conf.erb"
end

# service "apache2" do
#   action :restart
# end