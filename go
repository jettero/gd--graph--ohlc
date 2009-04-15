#!/usr/bin/perl -Iblib/lib

BEGIN {
    my @mtime = map {(stat $_)[9]} qw(Makefile Makefile.PL);
    system (qw(perl Makefile.PL)) if $mtime[0] != $mtime[1];
    system (qw(make -f Makefile));
}

use strict;
use List::Util qw(min max);
use GD::Graph::ohlc;
use GD::Graph::mixed;

my @msft = (   #  open      high         low        close
  ["2007/12/18", "34.6400", "35.0000", "34.2100", "34.7400"],
  ["2007/12/19", "34.6900", "35.1400", "34.3800", "34.7900"],
  ["2007/12/20", "35.2900", "35.7900", "35.0800", "35.5200"],
  ["2007/12/21", "35.9000", "36.0600", "35.7500", "36.0600"],
  ["2007/12/24", "36.1300", "36.7200", "36.0500", "36.5800"],
  ["2007/12/26", "36.4100", "36.6400", "36.2600", "36.6100"],
  ["2007/12/27", "36.3500", "36.5500", "35.9400", "35.9700"],
  ["2007/12/28", "36.1000", "36.2300", "35.6700", "36.1200"],
  ["2007/12/31", "35.9000", "35.9900", "35.5200", "35.6000"],
  ["2008/01/02", "35.7900", "35.9600", "35.0000", "35.2200"],
  ["2008/01/03", "35.2200", "35.6500", "34.8600", "35.3700"],
);

my $data_ohlc = [
    [ map {$_->[0]} @msft ],
    [ map {[@$_[1 .. 4]]} @msft ],
];

my $data_mixed = [ @$data_ohlc, [ map {$_->[4]} @msft ] ];


my @all_points = map {@$_[1 .. 4]} @msft[1 .. $#msft];
my $min_point  = min(@all_points);
my $max_point  = max(@all_points);

for my $type (qw(mixed ohlc)) {
    my $graph = eval "new GD::Graph::$type";
       $graph->set( 
            x_labels_vertical => 1,
            x_label           => 'X Label',
            y_label           => 'Y label',
            title             => "test $type",
            transparent       => 0,
            dclrs             => [qw(blue black)],
            types             => [qw(ohlc lines)],
            y_min_value       => $min_point-0.2,
            y_max_value       => $max_point+0.2,
            y_number_format   => '%0.2f',

        ) or warn $graph->error;

    my $gd = $graph->plot(eval "\$data_$type") or die $graph->error;
    open my $dump, ">dump-$type.png" or die $!;
    print $dump $gd->png;
    close $dump;
}

system(qw(gthumb dump-mixed.png));
system(qw(rm -v), glob("*.png"));
exit 0;
