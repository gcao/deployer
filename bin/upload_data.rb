#!/usr/bin/env ruby

# Use this command to download
#  scp root@`ami_host`:backup/*.tgz data/

raise "Environment variable CHEF_SSH_USER_HOST is not set" unless ssh_user_host = ENV["CHEF_SSH_USER_HOST"]

def run cmd
  puts cmd
  system(cmd)
end

run "scp data/* #{ssh_user_host}:/tmp/"

run "ssh #{ssh_user_host} 'cd /data/apps/bbs/current && tar xzf /tmp/bbs-images.tgz'"
run "ssh #{ssh_user_host} sudo sh -c 'cd /var/lib/mysql && tar xzf /tmp/mysql-bbs.tgz'"
run "ssh #{ssh_user_host} sudo sh -c 'cd /var/lib/mysql && tar xzf /tmp/mysql-ucenter.tgz'"
run "ssh #{ssh_user_host} sudo sh -c 'cd /var/lib/mysql && tar xzf /tmp/mysql-gocool.tgz'"
run "ssh #{ssh_user_host} 'cd /data/apps/gocool/shared && tar xzf /tmp/gocool-sgfs.tgz'"

