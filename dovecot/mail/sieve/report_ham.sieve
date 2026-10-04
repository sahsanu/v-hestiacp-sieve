require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

if environment :matches "imap.mailbox" "*" {
    set "mailbox" "${1}";
}

# Moving out of Spam into a trash/junk folder is deleting, not "not spam"
if string :is "${mailbox}" ["Trash", "Deleted Messages", "Deleted Items", "Junk", "Spam"] {
    stop;
}

if environment :matches "imap.user" "*" {
    set "username" "${1}";
}

pipe :copy "imapsieve_copy" [ "${username}", "ham" ];