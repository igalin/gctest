Chef server and a Chef client (any other configuration management orchestration will do as well)
Either the server or the client may be installed on whichever Linux platform of your choosing.
  https://api.chef.io/login was used as Chef server
  CentOS 7.3.1611 was used as node
  Windows 7 with Chef DK was used as workstation
The client would pull configuration settings from the server periodically
  Role feature (web.json) was used with explicit node['chef_client']['interval'] and node['chef_client']['splay'] attributes
  Pulls on average between 30-35 minutes
The client would apply the following recipes:
Measure CPU usage on the machine using vmstat. If an external package is needed to run it, it would verify it is installed on the machine.
  External package would be procps. Comes with CentOS by default.
Install a web server, NGINX, and make it listen to port 80 and 443.
  http(80), https(443) - default ports
  /etc/nginx/sites-available/default
  server {
    listen 80;
    listen 443 default_server ssl;
  }
Download latest Google logo from the Google website and store it under the /root directory. The system would download the file only if is doesn't exists or it is more than a day old.
  require 'open-uri'
  download = open('http://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png')
  IO.copy_stream(download, '/root/logo.png')
Delete any rotated compressed log files under /var/log or any sub-folder recursively.
  Use logrotate cookbook from Chef Supermarket and define it in the --run-list or role file(web.json <-defined in JSON file)
   https://supermarket.chef.io/cookbooks/logrotate/versions/2.1.0
   Define in Berksfile
      logrotate
   berks install
   
Bonus: NGINX serves a page with text and a picture that can get updated via git and rolled out by using configuration management (viva dynamic static content), but only if the file(s) in git are newer than the ones on the system and should be atomically updated.
    index.html.erb file in /templates folder on git would serve this purpose
    file resources atomic_update property would be set true if necessary since global setting found in the client.rb file         "file_atomic_update" has a default value "true"
