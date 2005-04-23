#!/usr/bin/perl
#
# $Id$
# Copyright 2004,2005 - Michael Sinz
#
# This script handles the return of rss data.
#
require 'admin.pl';

## First, lets see if we are allowed to look here:
&checkAuthPath($cgi->path_info);

## For the RSS data we will show up to 1 day ago
## (you can change that here to be something else)
## Thus you will always get at least 1 entry
## and no more than 24 hours worth of entries.
my $endDate = `date "+%FT%T" -d "1 day ago"`;
chomp $endDate;
my $rev = "-r 'HEAD:{" . $endDate . "}' ";

## Months of the year (1 - 12)
my @months = ('?','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

## Get the local document URL
my $rssURL = &svn_URL($cgi->path_info);

## Split the repository from the path within the repository
my $rpath = &svn_REPO($cgi->path_info);
my $opath = &svn_RPATH($cgi->path_info);

## Now, lets build the correct command to run...
my $cmd = $SVN_CMD . ' log -v --xml ' . $rev . $rssURL;

my $log;
if ((defined $rpath)
   && (defined $opath)
   && (open(LOGXML,"$cmd |")))
{
   my $log = join('',<LOGXML>);
   close(LOGXML);

   my ($top) = ($log =~ m:(<\?.*?\?>):s);
   $top = '<?xml version="1.0"?>' if (!defined $top);

   ## Get the first date I can find...
   my ($topDate) = ($log =~ m:<date>(.*?)</date>:s);

   print "Content-type: text/xml\n"
       , "\n"
       , $top , "\n"
       , "<!-- Insurrection Web Tools for Subversion RSS Feed -->\n"
       , "<!-- Copyright (c) 2004,2005 - Michael Sinz         -->\n"
       , "<!-- http://www.sinz.org/Michael.Sinz/Insurrection/ -->\n"
       , '<rss version="2.0">'
       , '<channel>' , "\n"
       , '<title>' , &svn_XML_Escape($rpath) , '</title>' , "\n"
       , '<description>RSS Feed for repository ' , &svn_XML_Escape($rpath)
       ,   ': ' , &svn_XML_Escape($groupComments{$rpath . ':/'})
       , '</description>' , "\n"
       , '<link>' , &svn_XML_Escape($SVN_URL . $SVN_REPOSITORIES_URL . $rpath . $opath) , '</link>' , "\n"
       , '<generator>Insurrection RSS Feeder - ' , &svn_XML_Escape('$Id$') , '</generator>' , "\n";

   print '<pubDate>' , &dateFormat($topDate) , '</pubDate>'
       , '<lastBuildDate>' , &dateFormat($topDate) , '</lastBuildDate>' , "\n" if (defined $topDate);

   foreach my $entry ($log =~ m|(<logentry\s.*?</logentry>)|sg)
   {
      my ($revision) = ($entry =~ m:revision="(.+?)">:s);
      my ($author) = ($entry =~ m:<author>(.*?)</author>:s);
      my ($logmsg) = ($entry =~ m:<msg>(.*?)</msg>:s);
      my ($date) = ($entry =~ m:<date>(.*?)</date>:s);

      ## Convert line enders into escaped <br/>
      $logmsg =~ s:\n:&lt;br/&gt;:sg;

      ## If the author does not have a domain, add the default one
      $author .= $EMAIL_DOMAIN if (!($author =~ m/@/));

      ## Make the link to this individual log message.
      my $link = $SVN_URL . $SVN_URL_PATH . 'log.cgi/' . $rpath . $opath . '?r1=' . $revision . '&r2=' . $revision;

      ## Now, lets build the whole log message...
      my @addFiles = ($entry =~ m:<path\s+action="A">(.*?)</path>:sg);
      my @modFiles = ($entry =~ m:<path\s+action="M">(.*?)</path>:sg);
      my @rplFiles = ($entry =~ m:<path\s+action="R">(.*?)</path>:sg);
      my @delFiles = ($entry =~ m:<path\s+action="D">(.*?)</path>:sg);

      my $tmsg = '';
      $tmsg .= '<div>Added: '    . scalar(@addFiles) . '</div>' if (scalar(@addFiles) > 0);
      $tmsg .= '<div>Modified: ' . scalar(@modFiles) . '</div>' if (scalar(@modFiles) > 0);
      $tmsg .= '<div>Replaced: ' . scalar(@rplFiles) . '</div>' if (scalar(@rplFiles) > 0);
      $tmsg .= '<div>Deleted: '  . scalar(@delFiles) . '</div>' if (scalar(@delFiles) > 0);
      $tmsg .= '<div>';

      $logmsg = &svn_XML_Escape($tmsg) . $logmsg;

      $tmsg = '</div>';

      $logmsg .= &svn_XML_Escape($tmsg);

      print '<item>' , "\n"
          , '<title>Revision ' , $revision , '</title>'
          , '<pubDate>' , &dateFormat($date) , '</pubDate>'
          , '<author>' , $author , '</author>' , "\n"
          , '<link>' , &svn_XML_Escape($link) , '</link>' , "\n"
          , '<description>' , $logmsg , '</description>' , "\n"
          , '</item>' , "\n";
   }
   print '</channel>'
       , '</rss>';

}
else
{
   &svn_HEADER('SVN RSS - Subversion Server');

   print '<h1>Failed to access the log</h1>'
       , '<h3>Log command:</h3>'
       , '<pre>' , $cmd , '</pre>';

   &svn_TRAILER('$Id$',$cgi->remote_user);
}

sub dateFormat($isodate)
{
   my $isodate = shift;
   my $result = '?';

   if ($isodate =~ m/(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d:\d\d:\d\d)/)
   {
      $result = $3 . ' ' . $months[$2] . ' ' . $1 . ' ' . $4 . ' GMT';
   }

   return $result;
}
