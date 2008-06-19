#==========================================================================
#              Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#   Name:
#       GD::Graph::axestype.pm
#
# $Id: axestype.pm,v 1.45 2007/04/26 03:16:09 ben Exp $
#
#==========================================================================

package GD::Graph::ohlc;

use strict;
use GD::Graph::axestype;
use GD::Graph::utils qw(:all);

@GD::Graph::ohlc::ISA = qw(GD::Graph::axestype);
