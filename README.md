pwm
===

pwm is a secure password manager for the command-line.

[![Build Status](https://secure.travis-ci.org/nerab/pwm.png?branch=master)](http://travis-ci.org/nerab/pwm)

Installation
============
pwm is written in [Ruby](http://www.ruby-lang.org/) and can be installed using Ruby's [gem](http://rubygems.org/) package manager:

      gem install pwm

Basic Usage
===========
Before it can store passwords, pwm needs to initialize the password database. The database file is created with the `init` command and located by default at `~/.pwm.pstore`.

      pwm init

Storing a password requires a name under which the password can be retrieved later on:

      pwm put "Mail Account" s3cret

This command will store the password "s3cret" under the name "Mail Account". Later on this password can be retrieved using the get command:

      pwm get "Mail Account"

This command will print "s3cret" to the console (STDOUT).

For more usage information, invoke the help command:

      pwm help

Concept
=======
pwm is written in the UNIX tradition of having a tool do one thing, and do it well. With this in mind, password management becomes not much more than keeping a list of name-value pairs and securing it from unauthorized access (by encrypting the password database with a master password).

The whole topic becomes much more interesting when you start integrating a password manager into various tools and applications. There is no widely accepted standard for how password managers could hook into applications, and so almost every tool falls back to the system clipboard. Notable exceptions are modern browsers, which provide password manager integration by their generic plugin concepts.

pwm focuses on the command line where standard input (STDIN) and output (STDOUT) are the established way to share data between commands (applications). Therefore pwm was built with the following principles in mind:

  * All input is read from STDIN
  * All regular output (e.g. the password retrieved) goes to STDOUT
  * All messages and errors are printed to STDERR  (prevents side effects of the message)
  * Exit code is set to 0 for success and non-zero for errors

Security
========
When it comes to securing passwords, pwm does not make any compromises. It relies on the proven OpenSSL library for all encryption functions via the [Encryptor](https://github.com/shuber/encryptor) wrapper. The password store itself is a Ruby [PStore](http://ruby-doc.org/stdlib/libdoc/pstore/rdoc/PStore.html). All names and values are individually encrypted with the master password.

Code security is enforced with two major concepts:

1. The complete source code of pwm, and all libraries it uses, are open source. Therefore, everyone can freely inspect the complete source code of pwm, run penetration tests, etc.
1. Nearly 100% of pwm's code is covered by unit and acceptance tests. All tests are re-run whenever new code is pushed to the public git repository. All build and test results are published with the help of [Travis CI](http://travis-ci.org/nerab/pwm).

Integration
===========
When invoked on a console, pwm will ask for the master password to be typed into the console (using the [HighLine](http://highline.rubyforge.org) library). pwm also behaves well when run in a pipe. You can pipe the master password into pwm. Similarly, instead of printing the retrieved password to the console, pwm's output can be used as input for yet another program.For instance, the popular request for copying a password to the clipboard can be achieved by piping pwm's output into a clipboard application that reads from STDIN, e.g. pbcopy (Mac), xclip (Linux), clip (Windows >= Vista), putclip (cygwin).

Example on MacOS:

    pwm get nerab@example.com | pbcopy

Or, if you prefer to enter the master password via a regular dialog box, you can run the same command with the --gui flag:

    pwm get nerab@example.com --gui | pbcopy

By calling this line, the password stored under nerab@example.com is copied to the clipboard.

Backup & Restore
================
* Backup: Copy ~/.pwm.pstore (or whatever you pass in with --file) to a safe place.
* Restore: Replace ~/.pwm.pstore (or whatever you pass in with --file) with the version you kept in a safe place.

Export and Printing
===================
pwm provides a simple export into the HTML format with the following command:

    pwm export

This will print raw HTML markup on STDOUT, so it can be written into a file

    pwm export > my_passwords.html
    
and then viewed and printed with a browser. With [bcat](http://rtomayko.github.com/bcat/) the export can be directly piped into a browser:

    pwm export | bcat

Contributing to pwm
===================

* Check out the [latest master](http://github.com/nerab/pwm/) to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========
Copyright (c) 2012 Nicholas E. Rabenau. See [LICENSE.txt](https://raw.github.com/nerab/pwm/master/LICENSE.txt) for further details.