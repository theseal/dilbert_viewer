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
print <<'ENDHTML';
<script src="./jquery.min.js"></script>
<script src="./jquery.endless-scroll.js"></script>
<script type="text/javascript" charset="utf-8">
$(window).endlessScroll();
$(window).endlessScroll({
    fireOnce: true,
    fireDelay: 15,
    loader: '',
    insertAfter: "h3:last+p",
    data: function(p) {
    console.log(p)
    var future = new Date();
    future.setDate(future.getDate() - 29 - p);
    var day = future.getDate();
    var month = future.getMonth() + 1;
    if (day < 10) {
        day = "0" + day;
        parseInt(day);
    }
    if (month < 10) {
        month = "0" + month;
        parseInt(month);
    }
    var year = future.getFullYear();
    console.log (day,month,year);
    var url = "http://tjanster.idg.se/dilbertimages/dil" + year + month + day + ".gif";
    console.log (url);
    return '<h3>' + year + month + day + '</h3>\n<p><img src="' + url + '" alt="dil' + year + month + day + ' .gif"/></p>\n';
  }
});
</script>
<a href="https://github.com/theseal/dilbert_viewer"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png"></a>
ENDHTML

print $q->end_html;

sub print_strip {
    my $date = shift;
    print $q->h3($date) . "\n";
    print $q->p("<img src=\"http://tjanster.idg.se/dilbertimages/dil$date.gif\" alt=\"dil$date.gif\"/>") . "\n";
}
