`mkdir #{node[:bbs][:home]}/releases`
`chmod a+w #{node[:bbs][:home]} #{node[:bbs][:home]}/releases`

web_app "bbs" do
  docroot node[:bbs][:docroot]
  template "bbs.conf.erb"
end

# TODO: Download db and images from Amazon S3

# service "apache2" do
#   action :restart
# end
