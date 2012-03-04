pwm
===

pwm is a secure password manager for the command-line

[![Build Status](https://secure.travis-ci.org/nerab/pwm.png?branch=master)](http://travis-ci.org/nerab/pwm)

Usage Hints
===========
pwm will read the master password from STDIN when running in a pipe. That way you can ask for the master password with a GUI tool instead of using the console input.

    zenity --entry --hide-text --text "Please enter the master password:" --title "pwm" | pwm get nerab@github.com

    This command will request the pwm master password using zenity (gpassword may do the same) and pipe it into pwm, which will in turn print the password that is stored under nerab@github.com. Again, when running in a pipe, the output of pwm can be used as input for other programs.

Misc
====
* All errors are printed to STDERR in order to prevent accidential side effects of the error message.
* Exit code is set to 0 for success and non-zero for errors.
* Like sudo, pwm uses timestamp files to implement a ticketing system. After pwm was successfully unlocked, a ticket is granted for 5 minutes (this timeout is configurable). Each subsequent pwm command updates the ticket for another 5 minutes. This avoids the problem of leaving a shell where others can physically get to your keyboard.

Contributing to pwm
===================

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========
Copyright (c) 2012 Nicholas E. Rabenau. See LICENSE.txt for further details.
