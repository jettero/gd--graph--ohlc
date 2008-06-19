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

($GD::Graph::ohlc::VERSION) = '$Revision$' =~ /\s([\d.]+)/;
@GD::Graph::ohlc::ISA = qw(GD::Graph::axestype);
