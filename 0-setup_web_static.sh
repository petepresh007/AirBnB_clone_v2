#!/usr/bin/env bash
# Sets up a web server for deployment of web_static

if ! command -v nginx &> /dev/null
then
	sudo apt-get update
	sudo apt-get install -y nginx
fi

sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/
echo "This a fake file" > /data/web_static/releases/test/index.html

# Create symbolic link
if [ -L /data/web_static/current ];
then
	sudo rm -f /data/web_static/current
fi
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of /data/ to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
NGINX_CONFIG="/etc/nginx/sites-available/default"
sudo sed -i '/server_name _;/a \\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n' $NGINX_CONFIG

# Create symbolic link to enable Nginx configuration
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

sudo service nginx restart
