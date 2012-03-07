1. Only pressing enter in the GUI password box raises a NilClass error on the Mac. Must deal with empty passwords at app as well as lib level.

1. `pwm passwd [NEW_MASTER_PASSWORD]`

    Changes the master password to `NEW_MASTER_PASSWORD`. If `NEW_MASTER_PASSWORD` is present, no confirmation further password asked is requested. If `NEW_MASTER_PASSWORD` is not present, pwm will read two lines from STDIN, treating the first line as new password and the second line as password confirmation. The command will only succeed if both lines are the same.

1. `pwm delete KEY`

    Deletes the entry stored under KEY.

1.  Like sudo, pwm could become less annoying and ask rather seldom for the master password. After pwm was successfully unlocked, a ticket is granted for 5 minutes (this timeout is configurable). Each subsequent pwm command updates the ticket for another 5 minutes. This avoids the problem of leaving a shell where others can physically get to your keyboard.

    It's not simple to do with the current encryption concept. Because pwm uses symmetric encryption, entries cannot be read from the password database without the knowing the master password. We don't want to write the master password to disk, not do we want to decrypt the whole password database and store it somewhere.

1. Global option --ttl INTEGER

    Time to live for the authentication ticket.
    Pass in 0 to disable authentication tickets. In this case, pwm will ask for the master password for every invocation.
    Passing in -1 will make pwm not ask for the master password again until the ticket is manually deleted (e.g. by calling `pwm expire` in .logout).

1. `pwm expire`

    Expires an existing ticket (useful for placing in a .logout file).

1. `pwm alias EXISTING_KEY ALIAS_KEY`

    Creates a new alias for an existing key. All subsequent operations to `ALIAS_KEY` will operate on `EXISTING_KEY`.

1. The password input could be pluggable to that we could provide wrapper scripts for zenity, kdialog, cocoaDialog etc. A command line option would then select which one to use, while HighLine / STDIN stay the default.

    Alternatively, wrapper scripts like `gpwm`, `kpwm` and `macpwm` and even `wpwm` could be provided.

1. Exit codes should differe depending on the reason, so that shell scripts can react depending on the exit status of pwm. For instance, existing non-zero because a key was not found is different from a wrong master password.

1. Verbose mode should print statistics on STDERR, e.g. created, last modified, etc.

1. Store more data about each password, for instance
    * last modified (not just for the whole store)
    * last accessed (not just for the whole store)
    * password history
    * arbitrary meta data (user name, URL, comments, etc)

1. Find a way to include the output of `pwm help` in README.md so that Github and rdoc.info will always display the current synopsis (instead of writing it twice). A potential solution would be a Markdown help formatter for commander, which would be called from a Rake task or even a Git hook:

          pwm help --format md

    Default format would be text or ascii.

1. Printer-friendly export of clear-text passwords, maybe in JSON or another format that is easy to convert into something printable.
