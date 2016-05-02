use 5.010;
use strict;
use warnings;

##############################################################
#Generate HTML file
##############################################################
use lib 'HTML';
use lib 'CSS';
use HTML::Tiny;		#Changed name in directory from Tiny.pm to CTiny.pm
use CSS::Tiny;

use lib 'Switch';
use Switch;

use Block;

my $html_potato = HTML::Tiny->new( mode =>'html' );
my @blockList;


# SAMPLE INPUT

my $potato_block= Block -> new ("Name", "Title of document", Style->new(".0.", "25", ".0.", "head"));
$blockList[0] = $potato_block;


my $potato_block2= Block -> new ("Heading1", "Sample Page", Style->new(".0.", "18", "bold", "body"));

$blockList[1] = $potato_block2;


my $potato_block3= Block -> new ("Heading2", "Hi", Style->new(".0.", "16", "italic", "body", "#FF0000"));
$blockList[2] = $potato_block3;

my $potato_block4= Block -> new ("Normal", "Hello World", Style->new(".0.", "12", ".0.", "body", "blue"));
$blockList[3] = $potato_block4;

my $potato_block5= Block -> new ("Footer", "Second para", Style->new(".0.", "12", ".0.", "body", "blue"));
$blockList[4] = $potato_block5;
$potato_block5->setText("heellllooooo");

 $potato_block= Block -> new ("Name", "Title of document", Style->new(".0.", "25", ".0.", "head"));
$blockList[5] = $potato_block;

###################################################################################

my $htmlList;
my @htmlBody;
my @htmlHead;
my @htmlFoot;
my $tomato;

my @cssList;

#PARSING BLOCKLIST

foreach my $i (@blockList)
{
    my $temp = $i->getStyle_id();

    switch($temp)
    {
        case "Name"
        {
            push( @htmlHead , $html_potato->title($i->getText()));
        }
        case "Title"
        {
            push (@htmlBody,  $html_potato->h1($i->getText()));
        }
        case "Heading1"
        {
            push(@htmlBody ,  $html_potato->h2($i->getText()));
        }
        case "Heading2"
        {
            push (@htmlBody ,  $html_potato->h3($i->getText()));
        }
        case "Heading3"
        {
            push (@htmlBody , $html_potato->h4($i->getText()));
        }
        case "Header"
        {
            push (@htmlHead, $html_potato->header($i->getText()));
        }
        case "Footer"
        {
            push (@htmlFoot, $html_potato->p( $i->getText()));
        }
        case "Normal"
        {
            push (@htmlBody, $html_potato->p($i->getText()));
        }
        else {}
    }
}

# HTML HEADER

my $temp;

$temp = $htmlHead[0];

for my $k (1 .. $#htmlHead)
{
    $temp = $temp."\n".$htmlHead[$k];
}

$htmlList = $htmlList . $html_potato->head (["\n".$temp."\n"]);

# HTML BODY
$temp = $htmlBody[0];

for my $j (1 .. $#htmlBody)
{
    $temp = $temp."\n".$htmlBody[$j];
}

$htmlList = $htmlList . $html_potato->body (["\n".$temp]);

# HTML FOOTER
$temp = $htmlFoot[0];

for my $l (1 .. $#htmlFoot)
{
    $temp = $temp."\n".$htmlFoot[$l];
}

$tomato = $tomato . $html_potato->tag("footer",["\n".$temp]);

#PRINTING IN HTML FILE

open( my $file, '>', 'test.html');

print $file $html_potato->html(["\n".$htmlList, $tomato."\n"]);

close $file;

##############################################################
#Generate CSS file
##############################################################

my $css_potato = CSS::Tiny->new();

my ($h1, $h2, $p , $body) = @_;


$css_potato->{h1}->{'color'} = 'black' unless defined($h1->{'color'});
$css_potato->{p}->{'font-family'} = 'Arial' unless defined($p->{'font-family'});

$css_potato->{p}->{'color'} ='blue' unless defined($p->{'color'});
$css_potato->{body}->{'color'} = 'red' unless defined($body->{'color'});

#print $css_potato->html;
#print $css_potato->html(
#	[
#	$css_potato->{h1}->{'color'},
#	$css_potato->{p}->{'color'},
#	$css_potato->{p}->{'font-family'}
#	]
#);

print "\n\n";

$css_potato->write('hi.css');