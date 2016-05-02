#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Uncompress::Unzip qw(unzip $UnzipError);
use XML::LibXML;
#use XML::LibXML::Documents;

use Block;
use Style;

#say "Hello";
#Parsing 

rename("test.docx", "test.docx.zip");

my $zipped = "test.docx.zip";
my $docBuffer = "doc.xml";
my $headerBuffer = "head.xml";
my $footerBuffer = "foot.xml";

unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";
unzip $zipped => $headerBuffer, Name=> "word/header1.xml" or die "unzip head failed: $UnzipError\n";
unzip $zipped => $footerBuffer, Name=> "word/footer1.xml" or die "unzip foot failed: $UnzipError\n";


open(my $doc,  "<",  "doc.xml") and print("doc success") or die "Can't open document.xml: $!";
open(my $header, "<",  "head.xml") and print("header success") or die "Can't open header.xml: $!";
open(my $footer, "<", "foot.xml")   and print("footer success")  or die "Can't open footer.xml: $!";

my @docBlocks = parseDoc($docBuffer);
my @headBlocks = parseDoc($headBuffer);
my @footBlocks = parseDoc($footBuffer);



close($doc) || die "Couldn't close file properly";
close($header) || die "Couldn't close file properly";
close($footer) || die "Couldn't close file properly";

rename("test.docx.zip", "test.docx");

sub parseDoc
{
    my $path = shift;
    my $dom = XML::LibXML->load_xml(location => $path);
    
    say '$dom is a ', ref($dom);
    say '$dom->nodeName is: ', $dom->nodeName;
    
    my @blockList;
    my $temp = Block->new();
    
    foreach my $wp ($dom->findnodes('//w:p'))
    {
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:pStyle'))
        {
            $temp->setStyle_id( $nodes->getAttribute("w:val"));
        }
        
        my $txt = "";
        foreach my $text  ($wp->findnodes('./w:r/w:t'))
        {
            $txt = $txt.$text->to_literal();
        }
        
        
        $temp->setText( $txt);
        
        push(@blockList, $temp);
    }

    return @blockList;
}



#Generating

###########################################
# 			HTML (using HTML::Tiny)
###########################################




###########################################
# 			CSS (Using CSS::Tiny)
###########################################