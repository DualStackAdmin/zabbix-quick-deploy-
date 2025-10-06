#!/bin/bash

#================================================================================
# ASCII Art Header
#================================================================================
clear

# Define a single color for the logo
GREEN='\033[0;32m'
NC='\033[0m' # No Color (to reset)

# Print the "TurkO" logo in a single tone
echo -e "${GREEN} ████████╗██╗   ██╗██████╗ ██╗  ██╗ ██████╗ ${NC}"
echo -e "${GREEN} ╚══██╔══╝██║   ██║██╔══██╗██║ ██╔╝██╔═══██╗${NC}"
echo -e "${GREEN}    ██║   ██║   ██║██████╔╝█████╔╝ ██║   ██║${NC}"
echo -e "${GREEN}    ██║   ██║   ██║██╔══██╗██╔═██╗ ██║   ██║${NC}"
echo -e "${GREEN}    ██║   ╚██████╔╝██║  ██║██║  ██╗╚██████╔╝${NC}"
echo -e "${GREEN}    ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ${NC}"

echo
echo "--- Zabbix Automatic and Advanced Optimization Script ---"
echo
sleep 2

#================================================================================
# Script Body
#================================================================================

# Ensure the script exits immediately if a command fails
set -e

# Check if the script is run as root (sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use 'sudo'." >&2
  exit 1
fi

# --- Step 1: System Prerequisites ---
echo "--> Step 1: Updating system and installing prerequisites..."
apt update && apt upgrade -y
apt install -y wget gnupg

# --- Interactive User Configuration ---
echo
echo "### Zabbix Installation Setup ###"
read -p "Enter the database name for Zabbix [zabbix]: " ZABBIX_DB_NAME
ZABBIX_DB_NAME=${ZABBIX_DB_NAME:-zabbix}

read -p "Enter the database username for Zabbix [zabbix]: " ZABBIX_DB_USER
ZABBIX_DB_USER=${ZABBIX_DB_USER:-zabbix}

read -sp "Enter a strong password for the database user '$ZABBIX_DB_USER': " ZABBIX_DB_PASSWORD
echo
if [ -z "$ZABBIX_DB_PASSWORD" ]; then
    echo "Database password cannot be empty. Exiting." >&2
    exit 1
fi

echo
echo "### Zabbix 7.4 Fully Optimized Installation Started ###"

# --- Step 2: Install Zabbix Repository ---
echo "--> Step 2: Downloading and installing the Zabbix repository..."
wget -q https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
apt update

# --- Step 3: Install Zabbix, Nginx, and MySQL ---
echo "--> Step 3: Installing Zabbix, Nginx, and MySQL server..."
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent2 mysql-server

# --- Step 4: Create and Configure Database ---
echo "--> Step 4: Creating and configuring the Zabbix database..."
mysql -e "DROP DATABASE IF EXISTS ${ZABBIX_DB_NAME};"
mysql -e "CREATE DATABASE ${ZABBIX_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -e "CREATE USER '${ZABBIX_DB_USER}'@'localhost' IDENTIFIED BY '${ZABBIX_DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${ZABBIX_DB_NAME}.* TO '${ZABBIX_DB_USER}'@'localhost';"
mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --user="${ZABBIX_DB_USER}" --password="${ZABBIX_DB_PASSWORD}" --database="${ZABBIX_DB_NAME}"
mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# --- Step 5: Advanced MySQL Performance Tuning ---
echo "--> Step 5: Applying Advanced MySQL performance optimizations..."
cat <<EOF > /etc/mysql/conf.d/zabbix-optimizations.cnf
[mysqld]
max_connections                 = 300
innodb_buffer_pool_size         = 800M
innodb_log_file_size            = 128M
innodb_log_buffer_size          = 128M
innodb_file_per_table           = 1
innodb_buffer_pool_instances    = 8
innodb_old_blocks_time          = 1000
innodb_stats_on_metadata        = off
innodb_flush_method             = O_DIRECT
innodb_log_files_in_group       = 2
innodb_flush_log_at_trx_commit  = 2
tmp_table_size                  = 96M
max_heap_table_size             = 96M
open_files_limit                = 65535
max_connect_errors              = 1000000
connect_timeout                 = 60
wait_timeout                    = 28800
EOF
chown mysql:mysql /etc/mysql/conf.d/zabbix-optimizations.cnf
chmod 644 /etc/mysql/conf.d/zabbix-optimizations.cnf

# --- Step 6: Configure Zabbix Server (Base Settings) ---
echo "--> Step 6: Configuring Zabbix server database connection..."
sed -i "s|# DBPassword=|DBPassword=${ZABBIX_DB_PASSWORD}|" /etc/zabbix/zabbix_server.conf
sed -i "s/^DBName=.*/DBName=${ZABBIX_DB_NAME}/" /etc/zabbix/zabbix_server.conf
sed -i "s/^DBUser=.*/DBUser=${ZABBIX_DB_USER}/" /etc/zabbix/zabbix_server.conf

# --- Step 7: Zabbix Server Performance Tuning ---
echo "--> Step 7: Applying Zabbix Server performance optimizations..."
cat <<EOF >> /etc/zabbix/zabbix_server.conf

# Zabbix Server Performance Tuning
StartPollers=100
StartPollersUnreachable=50
StartPingers=50
StartTrappers=10
StartDiscoverers=10
StartHTTPPollers=10
CacheSize=128M
HistoryCacheSize=64M
HistoryIndexCacheSize=32M
TrendCacheSize=32M
ValueCacheSize=256M
EOF

# --- Step 8: PHP Performance Tuning ---
echo "--> Step 8: Applying PHP performance optimizations..."
PHP_INI_FILE="/etc/php/8.3/fpm/php.ini"
sed -i "s/^max_execution_time = .*/max_execution_time = 300/" $PHP_INI_FILE
sed -i "s/^memory_limit = .*/memory_limit = 256M/" $PHP_INI_FILE
sed -i "s/^post_max_size = .*/post_max_size = 32M/" $PHP_INI_FILE
sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 16M/" $PHP_INI_FILE
sed -i "s/^max_input_time = .*/max_input_time = 300/" $PHP_INI_FILE
sed -i "s|;date.timezone =|date.timezone = Asia/Baku|" $PHP_INI_FILE

# --- Step 9: Configure Nginx ---
echo "--> Step 9: Configuring Nginx for Zabbix frontend..."
sed -i 's/# listen 80;/listen 80;/' /etc/zabbix/nginx.conf
sed -i 's/# server_name example.com;/server_name _;/' /etc/zabbix/nginx.conf
ln -s -f /etc/zabbix/nginx.conf /etc/nginx/sites-enabled/zabbix.conf
rm -f /etc/nginx/sites-enabled/default

# --- Step 10: Start and Enable All Services ---
echo "--> Step 10: Restarting and enabling all services..."
systemctl restart zabbix-server zabbix-agent2 mysql nginx php8.3-fpm
systemctl enable zabbix-server zabbix-agent2 mysql nginx php8.3-fpm

# --- Final Output ---
SERVER_IP=$(hostname -I | awk '{print $1}')
RANDOM_ADMIN_PASS=$(openssl rand -base64 16)
echo
echo "####################################################################"
echo "### Installation and Optimization Completed Successfully! ✅     ###"
echo "####################################################################"
echo
echo "You can now access the Zabbix web interface at:"
echo "http://$SERVER_IP/zabbix"
echo
echo "Default login credentials:"
echo "  Username: Admin"
echo "  Password: zabbix"
echo
echo "IMPORTANT: Please log in and change the default password immediately."
echo "We suggest using this secure, randomly generated password:"
echo "  --> New suggested password: $RANDOM_ADMIN_PASS"
echo
echo "####################################################################"
