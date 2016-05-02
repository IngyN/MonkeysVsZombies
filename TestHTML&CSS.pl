use 5.010;
use strict;
use warnings;

##############################################################
#Generate HTML file
##############################################################
use lib 'HTML';
#use lib 'C:/Perl64/site/lib/CSS';
use lib 'CSS';
use HTML::Tiny;		#Changed name in directory from Tiny.pm to CTiny.pm
use CSS::Tiny;

use lib 'Switch';
use Switch;

use Block;

my $html_potato = HTML::Tiny->new( mode =>'html' );
my @blockList;

my $potato_block= Block -> new ("Title", "Title of document", Style->new(".0.", "25", ".0.", "head"));
$blockList[0] = $potato_block;


my $potato_block2= Block -> new ("h1", "Sample Page", Style->new(".0.", "18", "bold", "body"));

$blockList[1] = $potato_block2;


my $potato_block3= Block -> new ("h2", "Hi", Style->new(".0.", "16", "italic", "body", "#FF0000"));
$blockList[2] = $potato_block3;

#say $blockList[2];

my $potato_block4= Block -> new ("p", "Hello World", Style->new(".0.", "12", ".0.", "body", "blue"));
$blockList[3] = $potato_block4;

my $potato_block5= Block -> new ("p", "Second para", Style->new(".0.", "12", ".0.", "body", "blue"));
$blockList[4] = $potato_block5;
$potato_block5->setText("heellllooooo");

say "pb", $potato_block5->getText();

say scalar @blockList;
my $shit = $blockList[2]->getText();

say $shit;

my @htmlList;
my @cssList;

say $blockList[1];

foreach my $i (@blockList)
{
    my $temp = $i->getStyle_id();
    switch($temp)
    {
        case "Name"
        {
            push (@htmlList, $html_potato->title ($i->{text}));
        }
        else {}
    }
}


say "Hello Ingy & Shehab";

open( my $file, '>', 'test.html');

print $file $html_potato->html([$htmlList[0]]);

close $file;

#my $html_potato = HTML::Tiny->new( mode =>'html' );

open($file, '>', 'hi.html');

my $head =  $html_potato->head( $html_potato->title( 'Sample page' ) );
print $file $html_potato->html([$head]);
 

print $file $html_potato->html(
    [
      $html_potato->head( $html_potato->title( 'Sample page' ) ),
      $html_potato->body(
        [
          $html_potato->h1( { class => 'main' }, 'Sample page' ),
          $html_potato->h2( {class =>'main'}, 'Hi'), 
          $html_potato->p( 'Hello, World', { class => 'detail' }, 'Second para' )
        ]
      )
    ]
  );

close $file;
print "\n\n";
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