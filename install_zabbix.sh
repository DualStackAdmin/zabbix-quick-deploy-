#!/bin/bash

# Zabbix 7.4 (Ubuntu 24.04, Nginx, MySQL) fully automatic installation script.
# This script automates the entire installation process.
# Repository: https://github.com/DualStackAdmin/zabbix-quick-deploy-

# Ensure the script exits immediately if a command fails
set -e

# --- User-configurable Parameter ---
# Set a strong password for the Zabbix database here.
ZABBIX_DB_PASSWORD='your_strong_db_password'


# Check if the script is run as root (sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script with 'sudo'." >&2
  exit 1
fi

echo "### Zabbix 7.4 Fully Automatic Installation Started ###"

# Step 1: Download and install the Zabbix repository (Updated with the stable 'latest' link)
echo "--> Step 1: Downloading and installing the Zabbix repository..."
wget https://repo.zabbix.com/zabbix/7.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.4-2+ubuntu24.04_all.deb -O zabbix-release.deb
dpkg -i zabbix-release.deb
apt update

# Step 2: Install Zabbix components and other required packages
echo "--> Step 2: Installing Zabbix server, frontend, agent, and MySQL server..."
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent2 mysql-server

# Step 3: Create the database and user for Zabbix in MySQL
echo "--> Step 3: Creating the database and user in MySQL..."
mysql -e "DROP DATABASE IF EXISTS zabbix;"
mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '$ZABBIX_DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"

# Step 4: Import the initial database schema
ZABBIX_SQL_FILE="/usr/share/zabbix/sql-scripts/mysql/server.sql.gz"
echo "--> Step 4: Importing database schema from '$ZABBIX_SQL_FILE'..."
zcat $ZABBIX_SQL_FILE | mysql --user=zabbix --password="$ZABBIX_DB_PASSWORD" --database=zabbix --default-character-set=utf8mb4
mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# Step 5: Configure the Zabbix server
echo "--> Step 5: Adding the database password to the Zabbix server configuration file..."
sed -i "s|# DBPassword=|DBPassword=$ZABBIX_DB_PASSWORD|" /etc/zabbix/zabbix_server.conf

# Step 6: Configure Nginx
echo "--> Step 6: Configuring Nginx for the Zabbix frontend..."
sed -i 's/# listen 80;/listen 80;/' /etc/zabbix/nginx.conf
sed -i 's/# server_name example.com;/server_name _;/' /etc/zabbix/nginx.conf
rm -f /etc/nginx/sites-enabled/default

# Step 7: Fix file permissions for the web configuration
echo "--> Step 7: Setting permissions for the web configuration directory..."
chown -R www-data:www-data /etc/zabbix/web/
chmod -R 775 /etc/zabbix/web/

# Step 8: Start and enable all services
echo "--> Step 8: Restarting and enabling all services..."
systemctl restart zabbix-server zabbix-agent2 nginx php8.3-fpm
systemctl enable zabbix-server zabbix-agent2 nginx php8.3-fpm

SERVER_IP=$(hostname -I | awk '{print $1}')
echo
echo "############################################################"
echo "### Installation Completed Successfully!                 ###"
echo "############################################################"
echo
echo "To access the Zabbix web interface, open this address in your browser:"
echo "http://$SERVER_IP"
echo
echo "Default login credentials:"
echo "  Username: Admin"
echo "  Password: zabbix"
echo
