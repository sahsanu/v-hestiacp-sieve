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

```

## Upgrading to Dovecot 2.4 (e.g. Ubuntu 24.04 → 26.04, Debian 12 → 13)

The installer selects the Dovecot 2.3 or 2.4 configuration at install time. After a
release upgrade that brings Dovecot 2.4, the old 2.3 `20-spamham.conf` stays in place
and Dovecot refuses to start (`mail_attribute_dict: Unknown setting`). Re-run the
installer; it migrates the configuration (a backup of the old file is kept as
`20-spamham.conf.dovecot23.bak`):

```bash
cd /usr/local/src/v-hestiacp-sieve
git pull
sudo bash install_spamham.sh
```
