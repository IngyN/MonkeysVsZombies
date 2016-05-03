#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use lib 'Switch';
use Switch;

package Style;

sub new ()
{
	my ($class, $font, $size, $type, $basedOn, $color) = @_;
	my $self = {};
    
    $self->{font} = $font;
    $self->{size} = $size;
    $self->{type} = $type;
    $self->{basedOn} = $basedOn;
    $self->{color} = $color;
    
    #say $self->{basedOn};
	switch($self->{basedOn})
	 {
	 	case "Title" {
			$self->{type}= "bold" unless (defined($type) and !($type eq ".0."));
			$self->{size}= "24" unless (defined($size) and !($size eq ".0."));
			}
		case "Heading1" {
			$self->{type}= "bold" unless (defined($type) and !($type eq ".0."));
			$self->{size}= "18" unless (defined($size) and !($size eq ".0."));
			}
		case "Heading2"  {
			$self->{type} = "italic" unless (defined($type) and !($type eq ".0."));
			$self->{size}= "16" unless (defined($size) and !($size eq ".0."));
			}
		case "Heading3"  {
			$self->{size}= "14" unless (defined($size) and !($size eq ".0."));
			}
		case "Heading4" {
			$self->{size} = "12" unless (defined($size) and !($size eq ".0."));
		}	
		case "Footer"  {
			$self->{size}= "10" unless (defined($size) and !($size eq ".0."));
			}
			#BasedOn = "Normal" + "Name"
			else  {
				}
		}
    say $self->{font} = "Times New Roman" unless (defined($font) and !($font eq ".0."));
    say $self->{size} = "12"  unless (defined($size) and !($size eq ".0."));# in pt
    say $self->{type} = "none"  unless (defined($type) and !($type eq ".0."));# type: bold, italic, none
    say $self->{basedOn} = "none"  unless (defined($basedOn) and !($basedOn eq ".0."));
    say $self->{color} = "#000000" unless (defined ($color) and !($color eq ".0.")) ;
    
	bless $self, $class;
    return $self;
}

sub getFont
{
	my $self = shift;
	return $self ->{font};
}

sub getColor
{
    my $self = shift;
    return $self ->{color};
}

sub getSize
{
	my $self = shift;
	return $self ->{size};
}

sub getType
{
	my $self = shift;
	return $self ->{type};
}

sub getBasedOn
{
	my $self = shift;
	return $self ->{basedOn};
}

sub setFont
{
	my ($self, $f) = @_;
	$self -> {font} = $f if defined ($f);
	return if defined($f);
}

sub setSize
{
	my ($self, $s) = @_;
	$self -> {size} = $s if defined ($s);
	return if defined($s);
}

sub setType
{
	my ($self, $t) = @_;
	$self -> {type} = $t if defined ($t);
	return if defined($t);
}

sub setBasedOn
{
	my ($self, $f) = @_;
	$self -> {basedOn} = $f if defined ($f);
	return if defined($f);
}

sub setColor
{
    my ($self, $f) = @_;
    $self -> {color} = $f if defined ($f);
    return if defined($f);
}

sub sameAs
{
   my $flag;
   my ($self, $rhs) = @_;
   if(($self->{font} eq $rhs->{font})
	and ($self->{color} eq $rhs->{color}) 
	and ($self->{size} eq $rhs->{size}) 
	and ($self->{type} eq $rhs->{type}))
	{
		$flag = 1;
	}
	else
	{
		$flag = 0;
	}
   return $flag;
}


1;