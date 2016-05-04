use 5.010;
use strict;
use warnings;
use Style;

package Block;
sub new
{
    my ($class, $style_id,  $text, $style, $style_type) = @_;
    my $self = {};
    
    $self->{style_id} = $style_id;
    $self->{text} = $text;
    $self->{style} = $style;
    $self->{style_type} = $style_type;
    
    $self->{style_id} = "Normal" unless  (defined($style_id) and !($style_id eq ".0."));
    $self->{text} = "" unless (defined($text) and !($text eq ".0."));
    $self->{style_type} = 0 unless (defined($style_type) and !($text eq ".0."));
    
    $self->{style} = Style->new()  unless (defined($style) and !($style eq ".0."));
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
sub setStyle
{
    my ($self, $style) = @_;
    $self->{style} = $style if defined($style);
}

sub setStyle_type
{
    my ($self, $style_type) = @_;
    $self->{style_type} = $style_type if defined($style_type);
}

sub getStyle_type
{
    my $self = shift;
    return $self ->{style_type};
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
sub getStyle
{
    my $self = shift;
    return $self ->{style};
}
1;
