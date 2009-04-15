#!/usr/bin/perl -Iblib/lib

BEGIN {
    my @mtime = map {(stat $_)[9]} qw(Makefile Makefile.PL);
    system (qw(perl Makefile.PL)) if $mtime[0] != $mtime[1];
    system (qw(make -f Makefile));
}

use File::Slurp qw(slurp);
my $pod = slurp("ohlc.pod");
   $pod =~ s/^.*=head1 EXAMPLE\n//s;
   $pod =~ s/\n=head1.*//s;

eval $pod;
die $@ if $@;

system(qw(eog dump-mixed.png));
system(qw(rm -v), glob("*.png"));
exit 0;
