#!/usr/bin/env ruby

# Use this command to download
#  scp root@`ami_host`:backup/*.tgz data/

raise "Environment variable CHEF_SSH_USER_HOST is not set" unless ssh_user_host = ENV["CHEF_SSH_USER_HOST"]

def run cmd
  puts cmd
  system(cmd)
end

run "ssh #{ssh_user_host} mkdir backup"
run "scp data/* #{ssh_user_host}:backup/"

run "ssh #{ssh_user_host} sudo /data/apps/extras/current/restore.sh"

