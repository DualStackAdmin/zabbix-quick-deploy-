# 🚀 Zabbix Quick Deploy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A fully automated script to install and configure a full Zabbix 7.4 stack (Nginx, MySQL, Zabbix Server, Zabbix Agent 2) on a clean Ubuntu 24.04 server in minutes.

This repository contains a fully automated script that handles the entire installation process, allowing you to deploy a production-ready Zabbix server with zero manual intervention after the initial setup.

---

## ✨ Features

* 🤖 **Fully Automated:** Once launched, the script runs non-interactively to complete the installation.
* ⏱️ **Fast Deployment:** Get a fully functional Zabbix server up and running in just a few minutes.
* 📦 **Complete Stack:** Installs the Zabbix server, Nginx web server, MySQL database, and Zabbix Agent 2.
* ✍️ **Easy & Secure Configuration:** Edit your secret password locally before running the script.

## 📋 Prerequisites

* 💻 **Operating System:** A clean, minimal installation of **Ubuntu 24.04 (Noble Numbat)**.
* 💾 **Server Resources (Recommended):**
    * CPU: 2 vCPU
    * RAM: 4 GB
    * Disk: 20 GB

## 🛠️ Usage

This method allows you to safely inspect and configure the script before execution.

### Step 1: Download the Script

Download the latest version of the script directly from this repository to your server using the following command:

```bash
curl -LO [https://raw.githubusercontent.com/DualStackAdmin/zabbix-quick-deploy-/main/install_zabbix.sh](https://raw.githubusercontent.com/DualStackAdmin/zabbix-quick-deploy-/main/install_zabbix.sh)
Step 2: Make the Script Executable
Grant the script execution permissions to make it runnable:

Bash

chmod +x install_zabbix.sh
Step 3: Set Your Password (Important!)
Now, open the script in a text editor to set your database password:

Bash

nano install_zabbix.sh
Inside the editor, find this line at the top of the script:

Bash

ZABBIX_DB_PASSWORD='your_strong_db_password'
Replace 'your_strong_db_password' with your own secure password. To save and exit, press Ctrl + X, then Y, and Enter.

Step 4: Run the Script
Everything is ready! Execute the script with sudo privileges:

Bash

sudo ./install_zabbix.sh
The script will now automate the rest of the process for you.

✅ Post-Installation
After the script finishes, it will display your server's IP address. You can access the Zabbix web interface by navigating to that IP in your web browser.

🌐 URL: http://<your-server-ip-address>

🔑 Login Credentials:

Username: Admin

Password: zabbix

🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

⚖️ License
This project is licensed under the MIT License. See the LICENSE file for details.
