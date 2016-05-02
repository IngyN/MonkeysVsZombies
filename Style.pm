#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

package Style;

sub new ()
{
	my ($class, $font, $size, $type, $basedOn) = @_;
	my $self = {};
    
    $self->{font} = "Times New Roman" unless (defined($font) and !($font eq ".0."));
    $self->{size} = "12"  unless (defined($size) and !($size eq ".0."));# in pt
    $self->{type} = "none"  unless (defined($type) and !($type eq ".0."));# type: bold, italic, none
    $self->{basedOn} = "none"  unless (defined($basedOn) and !($basedOn eq ".0."));
    
	bless $self, $class;
    return $self;
}

sub getFont
{
	my $self = shift;
	return $self ->{font};
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
	my ($self, $f) = @_;
	$self -> {size} = $f if defined ($f);
	return if defined($f);
}

sub setType
{
	my ($self, $f) = @_;
	$self -> {type} = $f if defined ($f);
	return if defined($f);
}

sub setBasedOn
{
	my ($self, $f) = @_;
	$self -> {basedOn} = $f if defined ($f);
	return if defined($f);
}

1;