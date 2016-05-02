#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Uncompress::Unzip qw(unzip $UnzipError);
use XML::LibXML;
#use XML::LibXML::Documents;

#use Block;

#say "Hello";
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

parseDoc($docBuffer);

#my $ae = Archive::Extract->new( archive => $zipped );
#my $checkExtract = $ae->extract or die $ae->error;
#
#my $dir = $ae->extract_path;
#print $dir;

close($doc) || die "Couldn't close file properly";
close($header) || die "Couldn't close file properly";
close($footer) || die "Couldn't close file properly";

sub parseDoc
{
    my $path = shift;
    my $dom = XML::LibXML->load_xml(location => $path);
    
    say '$dom is a ', ref($dom);
    say '$dom->nodeName is: ', $dom->nodeName;
    
    my @blockList;
    #my $temp = Block->new();
    
    foreach my $wp ($dom->findnodes('//w:p'))
    {
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:pStyle'))
        {
            say $nodes->getAttribute("w:val");
        }
        
        my $txt = "";
        foreach my $text  ($wp->findnodes('./w:r/w:t'))
        {
            $txt = $txt.$text->to_literal();
        }
        
        say $txt;
        #say $wp->to_literal();
    }

    return
}



#Generating

###########################################
# 			HTML (using HTML::Tiny)
###########################################




###########################################
# 			CSS (Using CSS::Tiny)
###########################################