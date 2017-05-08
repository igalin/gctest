#
# Cookbook:: gctest
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# install nginx server
# install procps package which includes vmstat(CentOS by default comes with it)
package ['nginx','procps']

bash 'CPU_usage' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  vmstat > /var/www/html/vmstat.txt
  EOH
end
# run nginx as a service and start it
service 'nginx' do
  action [:enable, :start]
end

# making sure nginx listens on ports 80, 443
file '/etc/nginx/sites-available/default' do
  content 'server {
    listen 80;
    listen 443 default_server ssl;
  }'
end

group 'web_admin'

user 'web_admin' do
	group 'web_admin'
	system true
	shell '/bin/bash'
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  mode '0644'
  owner 'web_admin'
  group 'web_admin'
end


# download Goolge Logo and save under /root/logo.png
require 'open-uri'
  download = open('http://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png')
  IO.copy_stream(download, '/root/logo.png')
