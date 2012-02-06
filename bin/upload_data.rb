#!/usr/bin/env ruby

# Use this command to download
#  scp root@`ami_host`:backup/*.tgz data/

raise "Environment variable CHEF_SSH_USER_HOST is not set" unless ssh_user_host = ENV["CHEF_SSH_USER_HOST"]

def run cmd
  puts cmd
  system(cmd)
end

run "scp data/* #{ssh_user_host}:/tmp/"

run "ssh #{ssh_user_host} sudo tar xzf /tmp/bbs-images.tgz -C /data/apps/bbs/current"
run "ssh #{ssh_user_host} sudo tar xzf /tmp/mysql-bbs.tgz -C /var/lib/mysql"
run "ssh #{ssh_user_host} sudo tar xzf /tmp/mysql-ucenter.tgz -C /var/lib/mysql"
run "ssh #{ssh_user_host} sudo tar xzf /tmp/mysql-gocool.tgz -C /var/lib/mysql"
run "ssh #{ssh_user_host} sudo restart mysql"
run "ssh #{ssh_user_host} sudo tar xzf /tmp/gocool-sgfs.tgz -C /data/apps/gocool/shared"

