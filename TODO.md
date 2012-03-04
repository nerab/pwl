1. Don't use HighLine if we are called from a pipe in order to not pollute the output.

1. `pwm list PATTERN`

    Lists entries that have a key matching PATTERN.

1. `pwm delete KEY`

    Deletes the entry stored under KEY.

1. `pwm alias EXISTING_KEY ALIAS_KEY`

    Creates a new alias for an existing key. All subsequent operations to `ALIAS_KEY` will operate on `EXISTING_KEY`.

1. `pwm passwd [NEW_MASTER_PASSWORD]`
    
    Changes the master password to `NEW_MASTER_PASSWORD`. If `NEW_MASTER_PASSWORD` is not present, it will be read from STDIN.

1. Read master password from STDIN. That way we can ask for it with a GUI tool instead of using the command line:
    
    zenity --entry --hide-text --text "Please enter the master password:" --title "pwm" | pwm get nerab@github.com

    This command will request the pwm master password using zenity (gpassword may do the same) and pipe it into pwm, which will in turn print the password that is stored under nerab@github.com.
  
1. Ticket system (with global option --ttl INTEGER)

    Time to live for the authentication ticket.
    Pass in 0 to disable authentication tickets. In this case, pwm will ask for the master password for every invocation.
    Passing in -1 will make pwm not ask for the master password again until the ticket is manually deleted (e.g. by calling `pwm expire` in .logout). 

1. `pwm expire`

    Expires an existing ticket (useful for placing in a .logout file).
    
1. Store more data about each password, for instance
    * last modified (not just for the whole store)
    * last accessed (not just for the whole store)
    * password history
    * arbitrary meta data (user name, URL, comments, etc)

1. Printer-friendly export of clear-text passwords, maybe in JSON or other format