#!/bin/bash
set -euo pipefail
yum update -y
yum install -y httpd

# Body includes "Hello World" for health checks and Terratest assertions
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html><head><title>${cluster_name}</title></head>
<body><h1>Hello World</h1><p>${cluster_name} — port ${server_port}</p></body></html>
EOF

sed -i "s/^Listen .*/Listen ${server_port}/" /etc/httpd/conf/httpd.conf
systemctl enable httpd
systemctl restart httpd
