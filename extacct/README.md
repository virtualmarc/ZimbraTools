ZimbraTools: SYSTEM
===========

This scripts configure Zimbra to send from external accounts!

In the Zimbra Admin console disable the DNS Lookups at teh Serversettings -> DNS

Create the following file:
/opt/zimbra/conf/relayhost_map
containing the e-mailaddresses and servers (line by line). 
Example line:
user@provider.tld smtp.server.de:port

Create another file:
/opt/zimbra/conf/relay_password
containing the e-mailaddresses, the usernames and the passwords (line by line).
Example line:
user@provider.tld username:password

Then run the script for your Zimbra Version:

extacct7.sh for ZCS 7.X and earlier
extacct8.sh for ZCS 8.X and newer
refeshacct.sh has to be run everytime you change relayhost_map and relay_password

This scripts have to be run as user Zimbra or user Root.

The last step is to enter the allowed from e-mailaddresses at the users config in the Admin console 
and create personalities in the user settings panel.
