#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

package Style;

sub new ()
{
	my ($class, $font, $size, $type, $basedOn, $color) = @_;
	my $self = {};
    
    $self->{font} = "Times New Roman" unless (defined($font) and !($font eq ".0."));
    $self->{size} = "12"  unless (defined($size) and !($size eq ".0."));# in pt
    $self->{type} = "none"  unless (defined($type) and !($type eq ".0."));# type: bold, italic, none
    $self->{basedOn} = "none"  unless (defined($basedOn) and !($basedOn eq ".0."));
    $self->{color} = "#000000" unless (defined ($color) and !($color eq ".0.")) ;
    
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
	return if defined($f);
}

sub setType
{
	my ($self, $t) = @_;
	$self -> {type} = $t if defined ($t);
	return if defined($f);
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


1;