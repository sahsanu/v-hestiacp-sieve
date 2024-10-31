# v-hestiacp-sieve
Autolearn spam ham
Clone repo to root, Run installspam.sh
It has files and dirs, the script moves them to thier place and sets premissions.
Cron runs daily adding to athe ll email moved from spam to anywhere but trash as HAM and anything moved to spam as Spam.

To install, using root user, execute these steps:

Note: If you don’t have git installed, install it with `apt install git`

    cd /usr/local/src/
    git clone https://github.com/sahsanu/v-hestiacp-sieve.git
    cd v-hestiacp-sieve/
    chmod +x installspam.sh
    ./installspam.sh
