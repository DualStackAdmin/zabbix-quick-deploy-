# Zabbix Quick Deploy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

🚀 Install a full Zabbix 7.4 stack (Nginx, MySQL, Zabbix Server, Zabbix Agent 2) on a clean Ubuntu 24.04 server in minutes with a single command.

This repository contains a fully automated script that handles the entire installation and configuration process, allowing you to deploy a production-ready Zabbix server with zero manual intervention.

---

## Features

* **Fully Automated:** The script runs without requiring any user input after launch.
* **Fast Deployment:** Get a fully functional Zabbix server up and running in just a few minutes.
* **Complete Stack:** Installs not just the Zabbix server, but also the Nginx web server, MySQL database, and Zabbix Agent 2.
* **One-Command-Install:** Uses a simple one-line command to run directly from GitHub.
* **Easy to Configure:** Requires editing only one variable—the database password—before running.

## Prerequisites

* **Operating System:** A clean, minimal installation of **Ubuntu 24.04 (Noble Numbat)**.
* **Server Resources (Recommended):**
    * CPU: 2 vCPU
    * RAM: 4 GB
    * Disk: 20 GB

## Usage

Using this script is incredibly simple.

### Step 1: Fork & Edit the Password

1.  **Fork** this repository to your own GitHub account by clicking the "Fork" button in the top-right corner.
2.  In your own forked repository, open the `install_zabbix.sh` file and click the edit (pencil) icon.
3.  Find the following line at the beginning of the script and replace `'your_strong_db_password'` with your own secure password:
    ```bash
    ZABBIX_DB_PASSWORD='your_strong_db_password'
    ```
4.  Commit the changes to save your new password.

### Step 2: Run the Magic Command

Log in to your clean Ubuntu 24.04 server via SSH and run the following command. Make sure to replace `YourGitHubUsername` with your actual GitHub username.

```bash
curl -sSL [https://raw.githubusercontent.com/YourGitHubUsername/zabbix-quick-deploy/main/install_zabbix.sh](https://raw.githubusercontent.com/YourGitHubUsername/zabbix-quick-deploy/main/install_zabbix.sh) | sudo bash
