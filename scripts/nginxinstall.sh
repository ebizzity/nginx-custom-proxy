#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2015 Microsoft Azure
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

apt-get update -y && apt-get upgrade -y
apt-get install -y nginx
echo "Hello World from host" $HOSTNAME "!" | sudo tee -a /var/www/html/index.html

sudo nginx -t && sudo service nginx reload

# Find IP address for NIC
eth0_ip="$(ifconfig eth0 | grep 'inet' | grep -v inet6 | cut -d: -f2 | awk '{print $1}')"

# Configure Ngnix to forward DNS request to Azure DNS resolover

if [ $3 == 'udp' ]
        then


                cat >> /etc/nginx/nginx.conf << EOF
                stream {
                        upstream dns_servers {
                        server $1:$2;
                }
                server {
                        listen $eth0_ip:$2 $3;
                        proxy_pass dns_servers;
                        proxy_responses 1;
                        error_log  /var/log/nginx/dns.log info;
                }
                }
                EOF
else
                cat >> /etc/nginx/nginx.conf << EOF
                stream {
                        upstream dns_servers {
                        server $1:$2;
                }
                server {
                        listen $eth0_ip:$2;
                        proxy_pass dns_servers;
                        proxy_responses 1;
                        error_log  /var/log/nginx/dns.log info;
                }
                }
                EOF
                
fi

# Restart Ngnix after config change

sudo service nginx restart