A simple command-line tool that blocks certain websites, and restarts the computer if a violation (someone ediiting the hosts file) is detected.

Works in Windows and Linux. 

Usage:

NoDetermination --help 
shows all usage options.

NoDetermination --websites "facebook.com, instagram.com, reddit.com"
will block these three websites in addition to the defaults.

NoDetermination --hosts /path/to/file
Will change the file to monitor to somewhere else; this is used for testing purposes.

NoDetermination --redirect random.dog
Changes where NoDetermination will redirect you. In this case, to random.dog

