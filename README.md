# Spam-Ham autolearn Installer for HestiaCP + Dovecot

This script installs and configures **Spam-Ham IMAPSieve** integration for **Dovecot**, compatible with **HestiaCP** mail servers.

It automates the setup of sieve rules, mail folders, and daily maintenance tasks to handle reported spam/ham messages.

---

## Features
- Detects Dovecot version (`2.4` or earlier)
- Automatically sets up:
  - `Spam` and `Ham` training folders
  - Sieve scripts for spam/ham reporting
  - Dovecot IMAPSieve configuration
  - Daily cron job to process reported messages
- Verifies HestiaCP installation before proceeding
- Ensures correct file permissions and ownership

---

## Requirements
- Root privileges
- HestiaCP installed
- Dovecot mail server
- Bash 4+

---

## Installation

Clone the repository and run the installer as **root**:

```bash
mkdir -p /usr/local/src/
cd /usr/local/src/
git clone https://github.com/sahsanu/v-hestiacp-sieve.git
cd v-hestiacp-sieve 
sudo bash install_spamham.sh

