* Read master password from STDIN. That way we can ask for it with a GUI tool:
    
    zenity --entry --hide-text --text "Please enter the master password:" --title "pwm" | pwm get nerab@github.com

  This command will request the pwm master password using zenity (gpassword may do the same) and pipe it into pwm, which will in turn print the password that is stored under nerab@github.com.