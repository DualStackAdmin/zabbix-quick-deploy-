# 🚀 Zabbix Quick Deploy (Advanced Optimization & Stable Version)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An enhanced, fully automated script to install and **aggressively optimize** a full Zabbix 7.4 stack (Nginx, MySQL, Zabbix Server, Zabbix Agent 2) on a clean Ubuntu 24.04 server, preparing it for high-load environments.

This script handles the entire installation and configuration process, including advanced performance tuning for the Zabbix Server, MySQL, and PHP, allowing you to deploy a production-ready Zabbix server with minimal effort.

---

## ✨ Features

* ✅ **System Update & Prep:** Automatically runs `apt update && apt upgrade` to ensure all system packages are up-to-date before installation begins.
* 🤖 **Interactive & Secure Setup:** Prompts you to securely enter your database credentials (name, user, password) during runtime.
* 🚀 **Advanced Zabbix Server Tuning:** Automatically configures key performance parameters like `StartPollers`, `CacheSize`, `ValueCacheSize`, and trappers for high-load environments.
* ⚡ **Advanced MySQL Tuning:** Creates a dedicated configuration file to optimize MySQL for Zabbix, tuning `max_connections`, `innodb_buffer_pool_size`, and many other critical variables for maximum performance.
* ⚙️ **Automated Database Management:** Creates the MySQL database and user, grants the necessary permissions, and imports the initial Zabbix schema automatically.
* 📦 **Complete & Modern Stack:** Installs Zabbix 7.4, Nginx, MySQL, and the modern Zabbix Agent 2.
* 🌍 **Timezone Aware:** Automatically sets the PHP timezone to `Asia/Baku` for correct time display in the frontend.

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

### Step 1: Download the Script
```bash
wget https://github.com/DualStackAdmin/zabbix-quick-deploy-/blob/main/install_zabbix_ubuntu_24.04.sh
```

### Step 2: Make the Script Executable
```bash
chmod +x install_zabbix_ubuntu_24.04.sh
```

### Step 3: Run the Script
Execute the script with `sudo` privileges.
```bash
sudo ./install_zabbix_ubuntu_24.04.sh
```
The script will now become interactive and ask for the following details to configure the database:

* **Database Name:** The name for the Zabbix database. Press **Enter** to use the default (`zabbix`).
* **Database User:** The MySQL user for Zabbix. Press **Enter** to use the default (`zabbix`).
* **Database Password:** A strong password for the user. Your input will be hidden for security.

After you provide this information, the script will complete the entire installation and optimization automatically.

---

### ✅ Post-Installation

After the script finishes, it will display your server's IP address and login details.

🌐 **URL:** `http://<your-server-ip-address>`

🔑 **Login Credentials:**
* Username: `Admin`
* Password: `zabbix`

For security, you should log in immediately and change the default password. The script will also suggest a strong, randomly generated password for you to use.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## ⚖️ License

This project is licensed under the **MIT License**.
See the `LICENSE` file for details.
