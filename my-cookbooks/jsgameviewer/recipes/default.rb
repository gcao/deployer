`mkdir -p #{node[:jsgameviewer][:home]}/releases #{node[:jsgameviewer][:home]}/shared/config`
`chmod a+w #{node[:jsgameviewer][:home]} #{node[:jsgameviewer][:home]}/releases`

web_app "jsgameviewer" do
  docroot node[:jsgameviewer][:docroot]
  template "jsgameviewer.conf.erb"
end

