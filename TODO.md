1. `pwm list PATTERN`

    Lists entries that have a key matching PATTERN.

1. `pwm delete KEY`

    Deletes the entry stored under KEY.

1. `pwm passwd [NEW_MASTER_PASSWORD]`
    
    Changes the master password to `NEW_MASTER_PASSWORD`. If `NEW_MASTER_PASSWORD` is not present, it will be read from STDIN.

1.  Like sudo, pwm could become less annoying and ask rather seldom for the master password. After pwm was successfully unlocked, a ticket is granted for 5 minutes (this timeout is configurable). Each subsequent pwm command updates the ticket for another 5 minutes. This avoids the problem of leaving a shell where others can physically get to your keyboard.

1. Global option --ttl INTEGER

    Time to live for the authentication ticket.
    Pass in 0 to disable authentication tickets. In this case, pwm will ask for the master password for every invocation.
    Passing in -1 will make pwm not ask for the master password again until the ticket is manually deleted (e.g. by calling `pwm expire` in .logout). 

1. `pwm expire`

    Expires an existing ticket (useful for placing in a .logout file).
    
1. `pwm alias EXISTING_KEY ALIAS_KEY`

    Creates a new alias for an existing key. All subsequent operations to `ALIAS_KEY` will operate on `EXISTING_KEY`.

1. Store more data about each password, for instance
    * last modified (not just for the whole store)
    * last accessed (not just for the whole store)
    * password history
    * arbitrary meta data (user name, URL, comments, etc)

1. Find a way to include the output of `pwm help` in README.md so that Github and rdoc.info will always display the current synopsis (instead of writing it twice). A potential solution would be a Markdown help formatter for commander, which would be called from a Rake task or even a Git hook.

1. Printer-friendly export of clear-text passwords, maybe in JSON or other format