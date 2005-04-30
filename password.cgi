#!/usr/bin/perl
#
# $Id$
# Copyright 2004,2005 - Michael Sinz
#
# This script handles the management of the web/svn passwords
#
# Note that we track the changes via Subversion itself - that
# is, the password file is in the Subversion repository
#
require 'admin.pl';

# From our CGI context, get some information
my $Operation = $cgi->param('Operation');
$Operation = "" if (!defined $Operation);

if ($AuthUser eq 'demo')
{
   print $cgi->redirect($SVN_URL_PATH . 'admin.cgi');
   exit 0;
}

if ($Operation eq 'Cancel')
{
   print $cgi->redirect($SVN_URL_PATH);
   exit 0;
}

&svn_HEADER('Change Password - Insurrection Server');

print '<h2 align="center">Change Password</h2>'
    , '<p>This page lets you change your password for the Insurrection server.</p>'
    , '<p>You are logged on as: <font size="+1"><b>' , $AuthUser , '</b></font></p>';

my $changed = 0;

if ($Operation eq 'Update')
{
   &lockPasswordFile();

   &loadPasswordFile();

   my $Password0 = $cgi->param('Password0');
   my $Password1 = $cgi->param('Password1');
   my $Password2 = $cgi->param('Password2');

   $Password0 = 'x' if (!defined $Password0);
   $Password1 = 'y' if (!defined $Password1);
   $Password2 = 'z' if (!defined $Password2);

   if ($Password1 ne $Password2)
   {
      print '<h2 align=center><font color=red>New passwords did not match.</font></h1>';
   }
   elsif ($Password0 eq $Password1)
   {
      print '<h2 align=center><font color=red>New password matches old password.</font></h1>';
   }
   elsif (length($Password1) < 6)
   {
      print '<h2 align=center><font color=red>Passwords must be at least 6 characters.</font></h1>';
   }
   elsif (crypt($Password0,$userPasswords{$AuthUser}) ne $userPasswords{$AuthUser})
   {
      print '<h2 align=center><font color=red>Incorrect old password.</font></h1>';
   }
   else
   {
      $userPasswords{$AuthUser} = crypt($Password1,$AuthUser);
      &savePasswordFile('password.cgi: Password changed');

      print '<h2 align=center><font color=green>Password successfully changed.</font></h2>'
          , '<p>You will need to <a href="?">log in again</a> as your password has changed.</p>';

      $changed = 1;
   }

   &unlockPasswordFile();
}

print q(<center><form method=post>
<table border=0 cellpadding=1 cellspacing=3>
<tr><td align=right>Old password:</td><td align=left>&nbsp;<input type=password size=16 maxlength=16 name=Password0></td></tr>
<tr><td align=right>New password:</td><td align=left>&nbsp;<input type=password size=16 maxlength=16 name=Password1></td></tr>
<tr><td align=right>&nbsp;&nbsp;again:</td><td align=left>&nbsp;<input type=password size=16 maxlength=16 name=Password2></td></tr>
<tr><td align=right><input type=submit name="Operation" value="Cancel">&nbsp;</td><td align=left>&nbsp;<input type=submit name="Operation" value="Update"></td></tr>
</table>
</form></center>
) if (!$changed);

&svn_TRAILER('$Id$');

# all done...
exit 0;

