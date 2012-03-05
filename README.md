pwm
===

pwm is a secure password manager for the command-line.

[![Build Status](https://secure.travis-ci.org/nerab/pwm.png?branch=master)](http://travis-ci.org/nerab/pwm)

Concept
=======
pwm is written in the UNIX tradition of having a tool do one thing, and do it well. With this in mind, password management becomes not much more than keeping a list of key-value pairs and securing it from unauthorized access (by encrypting the password database with a master key).

The whole topic becomes much more interesting when you start integrating a password manager into various tools and applications. There is no widely accepted standard for how password managers could hook into applications, and so almost every tool falls back to the system clipboard. Notable exceptions are modern browsers, which provide password manager integration by their generic plugin concepts.

pwm focuses on the command line where standard input (STDIN) and output (STDOUT) are the established way to share data between commands (applications). Therefore pwm was built with the following principles in mind:

  * All input is read from STDIN
  * All regular output (e.g. the password retrieved) goes to STDOUT
  * All messages and errors are printed to STDERR  (prevents side effects of the message)
  * Exit code is set to 0 for success and non-zero for errors

Security
========
When it comes to securing passwords, pwm does not make compromises. It relies on the proven OpenSSL library for all encryption functions via the [Encryptor](https://github.com/shuber/encryptor) wrapper. The password store itself is a Ruby [PStore](http://ruby-doc.org/stdlib/libdoc/pstore/rdoc/PStore.html). All keys and values are individually encrypted with the master key.

Integration
===========
pwm will read the master password from STDIN when running in a pipe. Therefore you can ask for the master password with a GUI tool instead of using the console input.

* On Linux, [gdialog](http://linux.about.com/library/cmd/blcmdl1_gdialog.htm) or [kdialog](http://techbase.kde.org/Development/Tutorials/Shell_Scripting_with_KDE_Dialogs#Example_1:_Password_Dialog) or [Zenity](http://live.gnome.org/Zenity) could be used.

      Example for Zenity:

          zenity --entry --hide-text --text "Please enter the master password:" --title pwm | pwm get nerab@github.com

* On the Mac, [CocoaDialog](http://mstratman.github.com/cocoadialog/) or [Pashua](http://www.bluem.net/en/mac/pashua/) could be used. If you have CocoaDialog installed, the following snippet will work on MacOS:

          /Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog secure-standard-inputbox --title pwm --informative-text "Please enter the master password:" | ruby -e "r = ARGF.read.split; puts r[1] if r[0] == '1'" | pwm get nerab@github.com

      This line is a little more involved because CocoaDialog returns two lines of output; first the number of the button that was pressed, and second the actual user input.

These commands will request the pwm master password using a GUI dialog. The result is piped into pwm, which will in turn print the password that is stored under nerab@github.com.

Instead of just printing to the console, the output of pwm can be used as input for other programs. For instance, the popular request for copying a password to the clipboard can be achieved by piping pwm's output into a clipboard application that reads from STDIN, e.g. pbcopy (Mac), xclip (Linux), clip (Windows >= Vista), putclip (cygwin).


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
Copyright (c) 2012 Nicholas E. Rabenau. See [LICENSE.txt](https://raw.github.com/nerab/pwm/master/LICENSE.txt) for further details.