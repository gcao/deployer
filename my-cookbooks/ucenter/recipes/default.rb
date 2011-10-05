`mkdir #{node[:ucenter][:home]}/releases`
`chmod a+w #{node[:ucenter][:home]} #{node[:ucenter][:home]}/releases`

web_app "ucenter" do
  docroot node[:ucenter][:docroot]
  template "ucenter.conf.erb"
end

