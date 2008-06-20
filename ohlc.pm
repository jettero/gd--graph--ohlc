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

# sub initialise {
#     my $self = shift;
#        $self->SUPER::initialise();
#        $self->set(correct_width => 1);
# }

sub draw_data_set {
    my $self = shift;
    my $ds   = shift;

    my @values = $self->{_data}->y_values($ds) or
        return $self->_set_error("Impossible illegal data set: $ds", $self->{_data}->error);

    return $ds;
}

sub draw_data {
    my $self = shift;
       $self->SUPER::draw_data() or return;

    return $self;
}

sub draw_values {
    my $self = shift;

    return $self unless $self->{show_values};
    my $has_args = @_;

    my @numPoints = $self->{_data}->num_points();
    my @datasets = $has_args ? @_ : 1 .. $self->{_data}->num_sets;

    for my $dsn ( @datasets ) {
        my @values = $self->{_data}->y_values($dsn) or
            return $self->_set_error("Impossible illegal data set: $dsn", $self->{_data}->error);
    }

    return $self
}

"Just another true value";
