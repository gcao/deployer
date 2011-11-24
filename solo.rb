cookbook_path File.join(File.dirname(__FILE__), "cookbooks"), File.join(File.dirname(__FILE__), "my-cookbooks")
file_store_path File.dirname(__FILE__)
file_cache_path File.dirname(__FILE__)
log_level :debug
Chef::Log::Formatter.show_time = false

