# 🚀 Zabbix Quick Deploy (Optimized Version)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An enhanced, fully automated script to install and **optimize** a full Zabbix 7.4 stack (Nginx, MySQL, Zabbix Server, Zabbix Agent 2) on a clean Ubuntu 24.04 server in minutes.

This script handles the entire installation and configuration process, including performance tuning for MySQL and PHP, allowing you to deploy a production-ready Zabbix server with minimal effort.

---

## ✨ Features

* 🤖 **Interactive & Secure Setup:** The script prompts you for database credentials during execution. No need to edit files and risk exposing passwords.
* ⚡ **Performance Tuned:** Automatically applies best-practice performance settings for MySQL and PHP to handle a larger number of hosts.
* 📦 **Complete & Modern Stack:** Installs Zabbix 7.4, Nginx, MySQL, and the modern Zabbix Agent 2.
* 🌍 **Timezone Aware:** Automatically sets the PHP timezone to `Asia/Baku` for correct time display in the frontend.
* ⏱️ **Fast Deployment:** Get a fully functional Zabbix server up and running in just a few minutes.

---

## 📋 Prerequisites

* 💻 **Operating System:** A clean, minimal installation of **Ubuntu 24.04 (Noble Numbat)**.
* 🌐 **Internet Access:** Required for downloading packages.
* 🔒 **Root or Sudo Privileges:** The script must be run with `sudo`.
* 💾 **Server Resources (Recommended):**
    * CPU: 2 vCPU
    * RAM: 4 GB
    * Disk: 20 GB

---

## 🛠️ Usage

The new process is simpler and more secure. You no longer need to edit any files manually.

### Step 1: Download the Script

Get the latest version of the script from the repository.
```bash
wget [https://raw.githubusercontent.com/DualStackAdmin/zabbix-quick-deploy-/main/install_zabbix_ubuntu_24.04.sh](https://raw.githubusercontent.com/DualStackAdmin/zabbix-quick-deploy-/main/install_zabbix_ubuntu_24.04.sh)
```

### Step 2: Make the Script Executable

Grant the script execution permissions.
```bash
chmod +x install_zabbix_ubuntu_24.04.sh
```

### Step 3: Run the Script

Execute the script with `sudo` privileges. It will guide you through the rest.
```bash
sudo ./install_zabbix_ubuntu_24.04.sh
```
The script will now pause and ask you to enter the database name, username, and password. After you provide them, it will automate the rest of the process.

---

### ✅ Post-Installation

After the script finishes, it will display your server's IP address and login details.

🌐 **URL:** `http://<your-server-ip-address>/zabbix`

🔑 **Login Credentials:**
* Username: `Admin`
* Password: `zabbix`

For security, you should log in immediately and change the default password. The script will also suggest a strong, randomly generated password for you to use.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check the issues page.

## ⚖️ License

This project is licensed under the **MIT License**.
See the `LICENSE` file for details.
