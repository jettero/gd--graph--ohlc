
use Test;

plan tests => 2;

ok( eval "use GD::Graph::ohlc; 1" );
ok( grep {m/::ohlc/} @GD::Graph::mixed::ISA );
