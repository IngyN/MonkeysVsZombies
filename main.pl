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

my $head1fail= my $head2fail = my $head3fail = my $foot1fail = my $foot2fail = my $foot3fail = 0;

################################

unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";

unzip $zipped => $header1Buffer, Name=> "word/header1.xml" or say "unzip head failed: $UnzipError\n" and $head1fail = 1;
unzip $zipped => $header2Buffer, Name=> "word/header2.xml" or say "unzip head failed: $UnzipError\n" and $head2fail = 1;
unzip $zipped => $header3Buffer, Name=> "word/header3.xml" or say "unzip head failed: $UnzipError\n" and $head3fail = 1;

unzip $zipped => $footer1Buffer, Name=> "word/footer1.xml" or say "unzip foot failed: $UnzipError\n"and $foot1fail = 1;
unzip $zipped => $footer2Buffer, Name=> "word/footer2.xml" or say "unzip foot failed: $UnzipError\n"and $foot2fail = 1;
unzip $zipped => $footer3Buffer, Name=> "word/footer3.xml" or say "unzip foot failed: $UnzipError\n"and $foot3fail = 1;

#say $head1fail , $head2fail, $head3fail, $foot1fail, $foot2fail, $foot3fail;
#####################################################
my @docBlocks = parseDoc($docBuffer);

my @head1, my @head2, my @head3;

if($head1fail ==0)
{
    @head1 = parseDoc($header1Buffer);
}
if($head2fail ==0)
{
    @head2 = parseDoc($header2Buffer);
}
if($head3fail ==0)
{
    @head3 = parseDoc($header3Buffer);
}

my @headBlocks = (@head1, @head2, @head3);

my @foot1, my @foot2, my @foot3;

if($foot1fail ==0)
{
    @foot1 = parseDoc($footer1Buffer);
}
if($foot2fail ==0)
{
    @foot2 = parseDoc($footer2Buffer);
}
if($foot3fail ==0)
{
    @foot3 = parseDoc($footer3Buffer);
}
my @footBlocks = (@foot1, @foot2, @foot3);

################################################
my $docName = Block->new ("Name", $filename);

my @fullDocBlockList = ($docName, @docBlocks , @headBlocks , @footBlocks);

for (my $i = 0; $i < @docBlocks; $i++)
{
    say $docBlocks[$i]->G;
}


#for (my $i = 0; $i < @headBlocks; $i++)
#{
#    say $headBlocks[$i]->getText();
#}
#
#for (my $i = 0; $i < @footBlocks; $i++) {
#    say $footBlocks[$i]->getText();
#}

closing();

#######################################################################
#Parse Document
#######################################################################
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
            styleTemp->set
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
        
        $styleTemp ->setBasedOn( $temp->getStyle_id);
        
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


sub closing
{
    rename($filename.".docx.zip", $filename.".docx");
    unlink("doc.xml");
    unlink("head1.xml");
    unlink("head2.xml");
    unlink("head3.xml");
    unlink("foot1.xml");
    unlink("foot2.xml");
    unlink("foot3.xml");
}

#Generating

###########################################
# 			HTML (using HTML::Tiny)
###########################################




###########################################
# 			CSS (Using CSS::Tiny)
###########################################