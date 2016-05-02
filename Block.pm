use 5.010;
use strict;
use warnings;
use Style;

package Block;
sub new 
{
	 my ($class, $style_id,  $text, $style) = @_;
	my $self = {};
	
	$style_id = "Normal" unless  (defined($style_id) and !($style_id eq ".0."));
	$text = "" unless (defined($text) and !($text eq ".0."));
	#$style = Style->new()  unless (defined($size) and !($size eq ".0."));	
	#This instruction will create an object of Style when we use the module

	bless ($self, $class);
	return $self;
}
sub setStyle_id
{
	my ($self, $style_id) = @_;
	$self->{style_id} = $style_id if defined($style_id);
}
sub setText
{
	my ($self, $text) = @_;
	$self->{text} = $text if defined($text);
}
sub getStyle_id
{
	my $self = shift;
	return $self ->{style_id};
}
sub getText
{
	my $self = shift;
	return $self ->{text};
}

