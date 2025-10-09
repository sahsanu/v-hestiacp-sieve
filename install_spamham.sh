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
    if grep report_spam.sieve /etc/dovecot/conf.d/15-mailboxes.conf &>/dev/null; then
        echo "Error: Spam-Ham is already configured" >&2
        exit 3
    else
        sed -i.bak -E '/^[[:space:]]*mailbox[[:space:]]+Spam[[:space:]]*\{/,/^[[:space:]]*}[[:space:]]*$/ {
    /^[[:space:]]*}[[:space:]]*$/ i\
        sieve_script report_spam {\
                type  = before\
                cause = copy append\
                path  = /var/mail/sieve/report_spam.sieve\
        }
}' /etc/dovecot/conf.d/15-mailboxes.conf
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

cat <<EOF >/etc/cron.daily/spamham
#!/bin/bash
/etc/dovecot/sieve/scan_reported_mails
EOF

chmod 755 /etc/cron.daily/spamham && chown root:root /etc/cron.daily/spamham

if systemctl restart dovecot; then
    echo "Spam-Ham has been installed"
else
    echo "Error restarting Dovecot" >&2
fi
