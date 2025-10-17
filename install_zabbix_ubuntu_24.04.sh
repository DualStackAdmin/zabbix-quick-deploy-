#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Root check
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}This script must be run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Zabbix 7.4 Installation Script${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Get database information from user
echo -e "${YELLOW}Enter database information:${NC}"
echo ""

read -p "Database name (default: zabbix): " DBNAME
DBNAME=${DBNAME:-zabbix}

read -p "Database username (default: zabbix): " DBUSER
DBUSER=${DBUSER:-zabbix}

read -sp "Database password: " DBPASS
echo ""

# Password validation
if [ -z "$DBPASS" ]; then
    echo -e "${RED}Password cannot be empty!${NC}"
    exit 1
fi

echo ""
read -p "MySQL root password (if exists, press Enter if none): " MYSQL_ROOT_PASS
echo ""

echo -e "${GREEN}Confirmation:${NC}"
echo "Database name: $DBNAME"
echo "Database username: $DBUSER"
echo ""
read -p "Do you want to continue? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo -e "${RED}Installation cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Starting installation...${NC}"
echo ""

# 1. Download Zabbix repository
echo -e "${YELLOW}[1/10] Downloading Zabbix repository...${NC}"
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
rm -f zabbix-release_latest_7.4+ubuntu24.04_all.deb

# 2. Update packages
echo -e "${YELLOW}[2/10] Updating package list...${NC}"
apt update

# 3. Install Zabbix components
echo -e "${YELLOW}[3/10] Installing Zabbix components...${NC}"
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2

# 4. Install Zabbix plugins
echo -e "${YELLOW}[4/10] Installing Zabbix plugins...${NC}"
apt install -y zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql

# 5. Install MySQL server
echo -e "${YELLOW}[5/10] Installing MySQL server...${NC}"
apt install -y mysql-server
systemctl start mysql
systemctl enable mysql

sleep 3

# 6. Create database
echo -e "${YELLOW}[6/10] Creating database...${NC}"

if [ -z "$MYSQL_ROOT_PASS" ]; then
    # No root password
    mysql <<EOF
CREATE DATABASE IF NOT EXISTS $DBNAME CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
EOF
else
    # With root password
    mysql -uroot -p"$MYSQL_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS $DBNAME CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
EOF
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}Error occurred while creating database!${NC}"
    exit 1
fi

# 7. Import Zabbix database structure
echo -e "${YELLOW}[7/10] Importing Zabbix database structure (this may take a few minutes)...${NC}"
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u"$DBUSER" -p"$DBPASS" "$DBNAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error occurred while importing database structure!${NC}"
    exit 1
fi

# 8. Advanced MySQL Performance Tuning
echo -e "${YELLOW}[8/11] Applying Advanced MySQL performance optimizations...${NC}"
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

# 9. Reset log_bin_trust_function_creators parameter
echo -e "${YELLOW}[9/11] Configuring MySQL parameters...${NC}"
if [ -z "$MYSQL_ROOT_PASS" ]; then
    mysql <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF
else
    mysql -uroot -p"$MYSQL_ROOT_PASS" <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF
fi

# 10. Edit Zabbix server configuration
echo -e "${YELLOW}[10/11] Configuring Zabbix server...${NC}"
sed -i "s/^# DBPassword=.*/DBPassword=$DBPASS/" /etc/zabbix/zabbix_server.conf
sed -i "s/^DBPassword=.*/DBPassword=$DBPASS/" /etc/zabbix/zabbix_server.conf
sed -i "s/^DBName=.*/DBName=$DBNAME/" /etc/zabbix/zabbix_server.conf
sed -i "s/^DBUser=.*/DBUser=$DBUSER/" /etc/zabbix/zabbix_server.conf

# 11. Start and enable services
echo -e "${YELLOW}[11/11] Starting services...${NC}"
systemctl restart mysql zabbix-server zabbix-agent2 apache2
systemctl enable mysql zabbix-server zabbix-agent2 apache2

sleep 3

# Status check
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Installation Completed!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${YELLOW}Service Status:${NC}"
systemctl is-active zabbix-server >/dev/null 2>&1 && echo -e "Zabbix Server: ${GREEN}Active${NC}" || echo -e "Zabbix Server: ${RED}Inactive${NC}"
systemctl is-active zabbix-agent2 >/dev/null 2>&1 && echo -e "Zabbix Agent2: ${GREEN}Active${NC}" || echo -e "Zabbix Agent2: ${RED}Inactive${NC}"
systemctl is-active apache2 >/dev/null 2>&1 && echo -e "Apache2: ${GREEN}Active${NC}" || echo -e "Apache2: ${RED}Inactive${NC}"
echo ""
echo -e "${GREEN}To access Zabbix web interface:${NC}"
echo -e "URL: ${YELLOW}http://$(hostname -I | awk '{print $1}')/zabbix${NC}"
echo -e "Default username: ${YELLOW}Admin${NC}"
echo -e "Default password: ${YELLOW}zabbix${NC}"
echo ""
echo -e "${RED}IMPORTANT: Change the default password immediately!${NC}"
echo ""
