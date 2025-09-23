# 🚀 Zabbix Quick Deploy

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An automated script to install and configure a full Zabbix 7.4 stack (Nginx, MySQL, Zabbix Server, Zabbix Agent 2) on a clean Ubuntu 24.04 server in minutes.

This repository contains a fully automated script that handles the entire installation process, allowing you to deploy a production-ready Zabbix server with minimal effort.

---

## ✨ Features

* 🤖 **Fully Automated:** Once launched, the script runs non-interactively to complete the installation.
* ⏱️ **Fast Deployment:** Get a fully functional Zabbix server up and running in just a few minutes.
* 📦 **Complete Stack:** Installs the Zabbix server, Nginx web server, MySQL database, and Zabbix Agent 2.
* ✍️ **Easy & Secure Configuration:** Edit your secret password locally on your server before running the script.

## 📋 Prerequisites

* 💻 **Operating System:** A clean, minimal installation of **Ubuntu 24.04 (Noble Numbat)**.
* 💾 **Server Resources (Recommended):**
    * CPU: 2 vCPU
    * RAM: 4 GB
    * Disk: 20 GB

## 🛠️ Usage

This method allows you to safely inspect and configure the script on your server before execution.

### Step 1: Download the Script

Download the latest version of the script directly from this repository to your server using the following command:

```bash
curl -LO https://raw.githubusercontent.com/DualStackAdmin/zabbix-quick-deploy-/main/install_zabbix.sh
