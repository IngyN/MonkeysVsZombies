use 5.010;
use strict;
use warnings;
##############################################################
#Generate HTML file
##############################################################
use lib 'C:/Perl64/site/lib/HTML';
#use lib 'C:/Perl64/site/lib/CSS';
use Tiny;

my $html_potato = HTML::Tiny->new( mode =>'html' );

#my $css_potato = CSS::Tiny->new();

 print $html_potato->html(
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
 
open( my $file, '>', 'hi.html');
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
close FILE;
print "\n\n";
##############################################################
#Generate CSS file
##############################################################
use lib 'C:/Perl64/site/lib/CSS';
use CTiny;		#Changed name in directory from Tiny.pm to CTiny.pm
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