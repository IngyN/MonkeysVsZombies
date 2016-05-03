use 5.010;
use strict;
use warnings;

use Style;

my $style1 = Style -> new ();
my $style2 = Style -> new ();

#$style1->{font} = "Times New Roman";
$style1-> setFont("Arial");
say "Check equality: ", $style1 -> sameAs($style2);