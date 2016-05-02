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
my $header1Buffer = "head1.xml";
my $header2Buffer = "head2.xml";
my $header3Buffer = "head3.xml";

my $footer1Buffer = "foot1.xml";
my $footer2Buffer = "foot2.xml";
my $footer3Buffer = "foot3.xml";

unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";

unzip $zipped => $header1Buffer, Name=> "word/header1.xml" or die "unzip head failed: $UnzipError\n";
unzip $zipped => $header2Buffer, Name=> "word/header2.xml" or die "unzip head failed: $UnzipError\n";
unzip $zipped => $header3Buffer, Name=> "word/header3.xml" or die "unzip head failed: $UnzipError\n";

unzip $zipped => $footer1Buffer, Name=> "word/footer1.xml" or die "unzip foot failed: $UnzipError\n";
unzip $zipped => $footer2Buffer, Name=> "word/footer2.xml" or die "unzip foot failed: $UnzipError\n";
unzip $zipped => $footer3Buffer, Name=> "word/footer3.xml" or die "unzip foot failed: $UnzipError\n";


my @docBlocks = parseDoc($docBuffer);
my @headBlocks = (parseDoc($header1Buffer), parseDoc($header2Buffer), parseDoc($header3Buffer));
my @footBlocks = (parseDoc($footer1Buffer), parseDoc($footer2Buffer), parseDoc($footer3Buffer));

for (my $i = 0; $i < @headBlocks; $i++)
{
    say $headBlocks[$i]->getStyle_id();
}

for (my $i = 0; $i < @footBlocks; $i++) {
    say $footBlocks[$i]->getStyle_id();
}


rename("test.docx.zip", "test.docx");

sub parseDoc
{
    my $path = shift;
    my $dom = XML::LibXML->load_xml(location => $path);
    
    say '$dom is a ', ref($dom);
    say '$dom->nodeName is: ', $dom->nodeName;
    
    my @blockList;
    my $temp;
    my $styleTemp;
    
    foreach my $wp ($dom->findnodes('//w:p'))
    {
        $temp= Block->new();
        $styleTemp = Style->new();
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:pStyle'))
        {
            $temp ->setStyle_id( $nodes->getAttribute("w:val"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:rFonts'))
        {
            $StyleTemp ->setFont( $nodes->getAttribute("w:ascii"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:color'))
        {
            $StyleTemp ->setColor( $nodes->getAttribute("w:val"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:sz'))
        {
            $StyleTemp ->setSize( $nodes->getAttribute("w:val"));
        }
        
        my $set = 0;
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:b'))
        {
            if ($set == 0)
            {
                $StyleTemp ->setType("b");
                $set = 1;
            }
            
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:i'))
        {
            if ($set == 0)
            {
                $StyleTemp ->setType("i");
                $set = 1;
            }
            else
            {
                $StyleTemp ->setType($StyleTemp ->getType."i");
                $set = 1;
            }
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:u'))
        {
            if ($set == 0)
            {
                $StyleTemp ->setType("u");
                $set = 1;
            }
            else
            {
                $StyleTemp ->setType($StyleTemp ->getType."u");
                $set = 1;
            }
        }

        
        my $txt = "";
        foreach my $text  ($wp->findnodes('./w:r/w:t'))
        {
            $txt = $txt.$text->to_literal();
        }
        
        $temp->setText( $txt);
#        my $t = \$temp;
        push(@blockList, $temp);
#        $temp->setText("");
#        $temp->setStyle_id("");
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