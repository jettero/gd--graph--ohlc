#==========================================================================
#              Copyright (c) 2008 Paul Miller
#--------------------------------------------------------------------------
#
#   Name:
#       GD::Graph::ohlc.pm
#
# $Id$
#
#==========================================================================
 
package GD::Graph::ohlc;

use strict;
use GD::Graph::axestype;
use GD::Graph::utils qw(:all);
use GD::Graph::colour qw(:colours);

use constant PI => 4 * atan2(1,1);

use vars qw(@ISA $VERSION);
($VERSION) = '$Revision 0.01$' =~ /\s([\d.]+)/;
@ISA = qw(GD::Graph::axestype);

sub draw_data_set {
    my $self = shift;
    my $ds   = shift;

    my @values = $self->{_data}->y_values($ds) or
        return $self->_set_error("Impossible illegal data set: $ds", $self->{_data}->error);

    # Pick a colour
    my $dsci = $self->set_clr($self->pick_data_clr($ds));

    for (my $i = 0; $i < @values; $i++) {
        my $value = $values[$i];
        next unless ref($value) eq "ARRAY" and @$value==4;
        my ($open, $high, $low, $close) = @$value;

        for my $p ([0, 8], [1, 3], [2, 9], [3, 2]) {
            my ($xp, $yp);
            if (defined($self->{x_min_value}) && defined($self->{x_max_value})) {
                ($xp, $yp) = $self->val_to_pixel($self->{_data}->get_x($i), $value->[$p->[0]], $ds);

            } else {
                ($xp, $yp) = $self->val_to_pixel($i+1, $value->[$p->[0]], $ds);
            }

            $self->marker($xp, $yp, $p->[1], $dsci );
            $self->{_hotspots}->[$ds]->[$i] = ['rect', $self->marker_coordinates($xp, $yp)];
        }
    }

    return $ds;
}

# Draw a marker
sub marker_coordinates {
    my $self = shift;
    my ($xp, $yp) = @_;

    return (
        $xp - $self->{marker_size},
        $xp + $self->{marker_size},
        $yp + $self->{marker_size},
        $yp - $self->{marker_size},
    );
}

sub marker {
    my $self = shift;
    my ($xp, $yp, $mtype, $mclr) = @_;
    return unless defined $mclr;

    my ($l, $r, $b, $t) = $self->marker_coordinates($xp, $yp);

    MARKER: {

        ($mtype == 1) && do 
        { # Square, filled
            $self->{graph}->filledRectangle($l, $t, $r, $b, $mclr);
            last MARKER;
        };
        ($mtype == 2) && do 
        { # Square, open
            $self->{graph}->rectangle($l, $t, $r, $b, $mclr);
            last MARKER;
        };
        ($mtype == 3) && do 
        { # Cross, horizontal
            $self->{graph}->line($l, $yp, $r, $yp, $mclr);
            $self->{graph}->line($xp, $t, $xp, $b, $mclr);
            last MARKER;
        };
        ($mtype == 4) && do 
        { # Cross, diagonal
            $self->{graph}->line($l, $b, $r, $t, $mclr);
            $self->{graph}->line($l, $t, $r, $b, $mclr);
            last MARKER;
        };
        ($mtype == 5) && do 
        { # Diamond, filled
            $self->{graph}->line($l, $yp, $xp, $t, $mclr);
            $self->{graph}->line($xp, $t, $r, $yp, $mclr);
            $self->{graph}->line($r, $yp, $xp, $b, $mclr);
            $self->{graph}->line($xp, $b, $l, $yp, $mclr);
            $self->{graph}->fillToBorder($xp, $yp, $mclr, $mclr);
            last MARKER;
        };
        ($mtype == 6) && do 
        { # Diamond, open
            $self->{graph}->line($l, $yp, $xp, $t, $mclr);
            $self->{graph}->line($xp, $t, $r, $yp, $mclr);
            $self->{graph}->line($r, $yp, $xp, $b, $mclr);
            $self->{graph}->line($xp, $b, $l, $yp, $mclr);
            last MARKER;
        };
        ($mtype == 7) && do 
        { # Circle, filled
            $self->{graph}->arc($xp, $yp, 2 * $self->{marker_size},
                         2 * $self->{marker_size}, 0, 360, $mclr);
            $self->{graph}->fillToBorder($xp, $yp, $mclr, $mclr);
            last MARKER;
        };
        ($mtype == 8) && do 
        { # Circle, open
            $self->{graph}->arc($xp, $yp, 2 * $self->{marker_size},
                         2 * $self->{marker_size}, 0, 360, $mclr);
            last MARKER;
        };
        ($mtype == 9) && do
        { # Horizontal line
            $self->{graph}->line($l, $yp, $r, $yp, $mclr);
            last MARKER;
        };
        ($mtype == 10) && do
        { # vertical line
            $self->{graph}->line($xp, $t, $xp, $b, $mclr);
            last MARKER;
        };
    }
}

"Just another true value";
