#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "Error: you must be root to execute this script" >&2
    exit 1
fi
if [[ ! -f /usr/local/hestia/func/main.sh ]]; then
    echo "Error: seems Hestia is not installed" >&2
    exit 2
fi
dov_spamham="20-spamham.conf"
dovecot_version="$(dovecot --version | cut -f -2 -d '.')"
if [[ "$dovecot_version" = "2.4" ]]; then
    dovconf="dovecot-24"
    # Older 2.4 installs added the report_spam hook to HestiaCP's 15-mailboxes.conf.
    # The hook now lives in 20-spamham.conf, so remove the old block (backup: .bak).
    if grep -q report_spam.sieve /etc/dovecot/conf.d/15-mailboxes.conf 2>/dev/null; then
        sed -i.bak -E '/^[[:space:]]*sieve_script[[:space:]]+report_spam[[:space:]]*\{/,/^[[:space:]]*}[[:space:]]*$/d' /etc/dovecot/conf.d/15-mailboxes.conf
        echo "Moved report_spam hook from 15-mailboxes.conf to $dov_spamham"
    fi
    # Dovecot 2.3 -> 2.4 (e.g. Ubuntu 24.04 -> 26.04 release upgrade): replace the 2.3 config
    if grep -q mail_attribute_dict "/etc/dovecot/conf.d/$dov_spamham" 2>/dev/null; then
        cp -a "/etc/dovecot/conf.d/$dov_spamham" "/etc/dovecot/conf.d/$dov_spamham.dovecot23.bak"
        echo "Migrating $dov_spamham to Dovecot 2.4 syntax (backup: $dov_spamham.dovecot23.bak)"
    fi
else
    dovconf="dovecot"
fi

mkdir -p /etc/dovecot/sieve
mkdir -p /var/mail/imapsieve_copy/{spam,ham}
cp -r "$dovconf"/conf.d/"$dov_spamham" /etc/dovecot/conf.d/"$dov_spamham"
cp -r "$dovconf"/mail/. /var/mail/
cp -r "$dovconf"/sieve/. /etc/dovecot/sieve/

chown -R mail:mail /var/mail
chmod -R 0775 /var/mail/imapsieve_copy
chmod 0755 /etc/dovecot/sieve/scan_reported_mails
chmod 0755 /etc/dovecot/sieve/imapsieve_copy
chmod 0775 /var/mail/sieve/
chmod 0644 /var/mail/sieve/*
rm -f /var/mail/sieve/*.svbin   # recompile with the running Dovecot version

cat <<EOF >/etc/cron.daily/spamham
#!/bin/bash
/etc/dovecot/sieve/scan_reported_mails
EOF

chmod 755 /etc/cron.daily/spamham && chown root:root /etc/cron.daily/spamham

if ! doveconf -n >/dev/null; then
    echo "Error: Dovecot configuration invalid, not restarting" >&2
    exit 4
fi

if systemctl restart dovecot; then
    echo "Spam-Ham has been installed"
else
    echo "Error restarting Dovecot" >&2
fi
