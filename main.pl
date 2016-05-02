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

my $filename = "multli";
rename($filename.".docx", $filename.".docx.zip");

my $zipped = $filename.".docx.zip";
my $docBuffer = "doc.xml";
my $header1Buffer = "head1.xml";
my $header2Buffer = "head2.xml";
my $header3Buffer = "head3.xml";

my $footer1Buffer = "foot1.xml";
my $footer2Buffer = "foot2.xml";
my $footer3Buffer = "foot3.xml";

my $docstat = my $h1stat = my $h2stat = my $h3stat = my $f1stat = my $f2stat = my $f3stat = " ";

 $docstat = unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";

 $h1stat = unzip $zipped => $header1Buffer, Name=> "word/header1.xml" or say "unzip head failed: $UnzipError\n";
 $h2stat = unzip $zipped => $header2Buffer, Name=> "word/header2.xml" or say "unzip head failed: $UnzipError\n";
 $h3stat = unzip $zipped => $header3Buffer, Name=> "word/header3.xml" or say "unzip head failed: $UnzipError\n";

 $f1stat = unzip $zipped => $footer1Buffer, Name=> "word/footer1.xml" or say "unzip foot failed: $UnzipError\n";
 $f2stat = unzip $zipped => $footer2Buffer, Name=> "word/footer2.xml" or say "unzip foot failed: $UnzipError\n";
 $f3stat = unzip $zipped => $footer3Buffer, Name=> "word/footer3.xml" or say "unzip foot failed: $UnzipError\n";


if ($docstat eq undef) {my @docBlocks = parseDoc($docBuffer) };

unless ($h1stat eq undef) {$h1stat = parseDoc($header1Buffer) } else { $h1stat=""};
unless ($h2stat eq undef) {$h2stat = parseDoc($header2Buffer) } else { $h1stat=""};
unless ($h3stat eq undef) {$h3stat = parseDoc($header3Buffer) } else { $h1stat=""};

my @headBlocks = $h1stat.$h2stat.$h3stat;

unless ($f1stat eq undef) {$f1stat = parseDoc($footer1Buffer) } else { $f1stat=""};
unless ($f2stat eq undef) {$f2stat = parseDoc($footer2Buffer) } else { $f1stat=""};
unless ($f3stat eq undef) {$f3stat = parseDoc($footer3Buffer) } else { $f1stat=""};

my @footBlocks = $f1stat.$f2stat.$f3stat;

for (my $i = 0; $i < @headBlocks; $i++)
{
    say $headBlocks[$i]->getStyle_id();
}

for (my $i = 0; $i < @footBlocks; $i++) {
    say $footBlocks[$i]->getStyle_id();
}


rename($filename.".docx.zip", $filename.".docx");

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
            $styleTemp ->setFont( $nodes->getAttribute("w:ascii"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:color'))
        {
            $styleTemp ->setColor( "#".$nodes->getAttribute("w:val"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:sz'))
        {
            $styleTemp ->setSize( $nodes->getAttribute("w:val"));
        }
        
        my $set = 0;
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:i'))
        {
            if ($set == 0)
            {
                $styleTemp ->setType("i");
                $set = 1;
            }
            
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:b'))
        {
            if ($set == 0)
            {
                $styleTemp ->setType("b");
                $set = 1;
            }
            else
            {
                $styleTemp ->setType($styleTemp ->getType."b");
                $set = 1;
            }
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:u'))
        {
            if ($set == 0)
            {
                $styleTemp ->setType("u");
                $set = 1;
            }
            else
            {
                $styleTemp ->setType($styleTemp ->getType."u");
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