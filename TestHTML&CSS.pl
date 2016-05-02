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


push(@blockList, $potato_block);

$potato_block= Block -> new ("h1", "Sample Page", Style->new(".0.", "18", "bold", "body"));
push(@blockList, $potato_block);

$potato_block= Block -> new ("h2", "Hi", Style->new(".0.", "16", "italic", "body", "#FF0000"));
push(@blockList, $potato_block);

$potato_block= Block -> new ("p", "Hello World", Style->new(".0.", "12", ".0.", "body", "blue"));
push(@blockList, $potato_block);

$potato_block= Block -> new ("p", "Second para", Style->new(".0.", "12", ".0.", "body", "blue"));
push(@blockList, $potato_block);

my @htmlList;
my @cssList;

foreach my $i (@blockList)
{
    
    switch(@blockList->[$i]->{style_id})
    {
        case "Name"
        {
            push (@htmlList, $html_potato->title (@blockList->[$i]->{text}));
        }
        else {}
    }
}


say "Hello Ingy & Shehab";

open( my $file, '>', 'test.html');

print $file $html_potato->html([@htmlList->[0]]);

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
print "End..\n";
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

print $css_potato->html;
#print $css_potato->html(
#	[
#	$css_potato->{h1}->{'color'},
#	$css_potato->{p}->{'color'},
#	$css_potato->{p}->{'font-family'}
#	]
#);

print "\n\n";

$css_potato->write('hi.css');