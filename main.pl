#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Uncompress::Unzip qw(unzip $UnzipError);
use XML::LibXML;
say "Hello";
#Parsing 

rename("/Users/Alia/Documents/TextProcessing/test.docx", "/Users/Alia/Documents/TextProcessing/test.docx.zip");

my $zipped = "/Users/Alia/Documents/TextProcessing/test.docx.zip";
my $docBuffer = "/Users/Alia/Documents/TextProcessing/doc.xml";
my $headerBuffer = "/Users/Alia/Documents/TextProcessing/head.xml";
my $footerBuffer = "/Users/Alia/Documents/TextProcessing/foot.xml";

unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";
unzip $zipped => $headerBuffer, Name=> "word/header1.xml" or die "unzip head failed: $UnzipError\n";
unzip $zipped => $footerBuffer, Name=> "word/footer1.xml" or die "unzip foot failed: $UnzipError\n";


open(my $doc,  "<",  "/Users/Alia/Documents/TextProcessing/doc.xml") and print("doc success") or die "Can't open document.xml: $!";
open(my $header, "<",  "/Users/Alia/Documents/TextProcessing/head.xml") and print("header success") or die "Can't open header.xml: $!";
open(my $footer, "<", "/Users/Alia/Documents/TextProcessing/foot.xml")   and print("footer success")  or die "Can't open footer.xml: $!";


#my $ae = Archive::Extract->new( archive => $zipped );
#my $checkExtract = $ae->extract or die $ae->error;
#
#my $dir = $ae->extract_path;
#print $dir;

sub parseDoc
{
    
}

close($doc) || die "Couldn't close file properly";
close($header) || die "Couldn't close file properly";
close($footer) || die "Couldn't close file properly";





#Generating

###########################################
# 			HTML (using HTML::Tiny)
###########################################




###########################################
# 			CSS (Using CSS::Tiny)
###########################################