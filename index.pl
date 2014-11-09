#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use POSIX qw(strftime);
use HTTP::Tiny;

my $q = new CGI;
my $style = '.future { background-color: lightgrey; }';
print $q->header( -charset => 'utf-8');
print $q->start_html( -title =>'Dilbert',
                      -style =>{ -code=>$style}
                    );

my @keywords = $q->keywords;
foreach (@keywords) {
    if ( $_ =~ /^future$/ ) {
        my $Client = HTTP::Tiny->new();
        print "<div class=\"future\">" . "\n";
        print $q->h5('&lt;future&gt;') . "\n";
        my $count = 0;
        while () {
            $count++;
            my $date = strftime "%Y%m%d", localtime(time() + 24*60*60*$count);
            my $url = "http://tjanster.idg.se/dilbertimages/dil$date.gif";
            my $response = $Client->get($url);
            my $content_type = $response->{headers}{'content-type'};
            if ( $content_type !~ /^image\/gif$/ ) {
                $count--;
                last;
            }
        }
        while ( $count > 0) {
            my $date = strftime "%Y%m%d", localtime(time() + 24*60*60*$count);
            print_strip($date);
            $count--;
        }
        print $q->h5('&lt;/future&gt;') . "\n";
        print "</div>" . "\n";

    }
}

my $count = 0;
while ($count < 30) {
    my $date = strftime "%Y%m%d", localtime(time() - 24*60*60*$count);
    print_strip($date);
    $count++;
}

print $q->end_html;

sub print_strip {
    my $date = shift;
    print $q->h3($date) . "\n";
    print $q->p("<img src=\"http://tjanster.idg.se/dilbertimages/dil$date.gif\" alt=\"dil$date.gif\"/>") . "\n";
}