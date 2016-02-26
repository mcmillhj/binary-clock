#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Term::ANSIColor qw(:constants);
use Term::Cap;
local $Term::ANSIColor::AUTORESET = 1;

sub get_time {
   my ($second, $minute, $hour) = localtime(time);

   my @hours   = (int $hour   / 10, int $hour   % 10);
   my @minutes = (int $minute / 10, int $minute % 10);
   my @seconds = (int $second / 10, int $second % 10);
   return 
         $hours[0]   << 20 
       | $hours[1]   << 16 
       | $minutes[0] << 12
       | $minutes[1] << 8
       | $seconds[0] << 4
       | $seconds[1];
}

sub draw {
    my $time = get_time();

    foreach my $i ( 23, 22, 21, 20 ) {
        my $j = $i;
        while ( $j >= 0 ) {
            (($time >> $j) & 1) == 1
                ? print WHITE "1 "
                : print  CYAN "0 ";
            $j -= 4;
        }
        print "\n";
    }
}

{
    my $terminal = Term::Cap->Tgetent( { OSPEED => 9600 } );
    my $clear_screen = $terminal->Tputs('cl');
        
    sub clear_screen {
        print $clear_screen;
    }
}

while ( 1 ) {
    draw();
    sleep 1;
    clear_screen();
}

END {
    print RESET;
}
