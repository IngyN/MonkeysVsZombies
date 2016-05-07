#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Uncompress::Unzip qw(unzip $UnzipError);
use XML::LibXML;
#use XML::LibXML::Documents;

use lib 'HTML';
use lib 'CSS';
use HTML::Tiny;		#Changed name in directory from Tiny.pm to CTiny.pm
use CSS::Tiny;
use lib 'Lingua';
use Lingua::EN::Numbers qw(num2en num2en_ordinal);

use lib 'Switch';
use Switch;
use Block;
use Style;

#say "Hello";
#Parsing

my $filename = "multli";
rename($filename.".docx", $filename.".docx.zip");

my $zipped = $filename.".docx.zip";

my $docBuffer = "doc.xml";
my $stylesBuffer = "styles.xml";
my $fontTableBuffer = "font.xml";

my $header1Buffer = "head1.xml";
my $header2Buffer = "head2.xml";
my $header3Buffer = "head3.xml";

my $footer1Buffer = "foot1.xml";
my $footer2Buffer = "foot2.xml";
my $footer3Buffer = "foot3.xml";

my $head1fail= my $head2fail = my $head3fail = my $foot1fail = my $foot2fail = my $foot3fail = 0;

################################

unzip $zipped => $docBuffer, Name=> "word/document.xml" or die "unzip doc failed: $UnzipError\n";
unzip $zipped => $stylesBuffer, Name=> "word/styles.xml" or die "unzip doc failed: $UnzipError\n";
unzip $zipped => $fontTableBuffer, Name=> "word/fontTable.xml" or die "unzip doc failed: $UnzipError\n";

unzip $zipped => $header1Buffer, Name=> "word/header1.xml" or say "unzip head failed: $UnzipError\n" and $head1fail = 1;
unzip $zipped => $header2Buffer, Name=> "word/header2.xml" or say "unzip head failed: $UnzipError\n" and $head2fail = 1;
unzip $zipped => $header3Buffer, Name=> "word/header3.xml" or say "unzip head failed: $UnzipError\n" and $head3fail = 1;

unzip $zipped => $footer1Buffer, Name=> "word/footer1.xml" or say "unzip foot failed: $UnzipError\n"and $foot1fail = 1;
unzip $zipped => $footer2Buffer, Name=> "word/footer2.xml" or say "unzip foot failed: $UnzipError\n"and $foot2fail = 1;
unzip $zipped => $footer3Buffer, Name=> "word/footer3.xml" or say "unzip foot failed: $UnzipError\n"and $foot3fail = 1;

#say $head1fail , $head2fail, $head3fail, $foot1fail, $foot2fail, $foot3fail;
#####################################################

my %defaultFonts = parseFonts($fontTableBuffer);

my @docBlocks = parseDoc($docBuffer);


say "fonts after parsefont";
say %defaultFonts;


#say "\n print docblocks here\n";
#for (my $i = 0; $i < @docBlocks; $i++)
#{
#    say $docBlocks[$i]->getText;
#    say $docBlocks[$i]->getStyle->getColor;
#    say " ";
#}

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
my $docName = Block->new(".0.",".0.",".0.",".0.", %defaultFonts);
$docName->setStyle_id("Name");
$docName->setText($filename);


push(my @arrname, $docName);

my @fullDocBlockList = (@arrname,  @headBlocks , @docBlocks , @footBlocks);

say "Postparsing";
for (my $i = 0; $i < @fullDocBlockList; $i++)
{
    say $fullDocBlockList[$i]->getText;
    say $fullDocBlockList[$i]->getStyle->getColor;
    say " ";
}


HTMLgen(@fullDocBlockList);
#CSSgen(@fullDocBlockList);

closing();

#######################################################################
#Parse Document
#######################################################################
sub parseStyles
{
    my $path = shift;
    my $lookForStyle = shift;
    
#    say " ";
#    say "lookfor is " , $lookForStyle;
    
    my $dom = XML::LibXML->load_xml(location => $path);

    my $styleTemp = Style->new('.0.','.0.','.0.','.0.','.0.', %defaultFonts);
    
    foreach my $wp ($dom->findnodes('//w:style'))
    {
        if($wp->getAttribute("w:styleId") eq $lookForStyle)
        {
            
            
            
            foreach my $nodes ( $wp->findnodes('./w:basedOn'))
            {
                $styleTemp ->setBasedOn( $nodes->getAttribute("w:val"));
            }
            
#                    foreach my $nodes ( $wp->findnodes('./w:rPr/w:rFonts'))
#                    {
#                        $styleTemp ->setFont( $nodes->getAttribute("w:ascii"));
#                    }
            
            foreach my $nodes ( $wp->findnodes('./w:rPr/w:color'))
            {
                $styleTemp ->setColor( "#".$nodes->getAttribute("w:val"));
            }
            
            foreach my $nodes ( $wp->findnodes('./w:rPr/w:sz'))
            {
                $styleTemp ->setSize( $nodes->getAttribute("w:val"));
            }
            
            my $set = 0;
            foreach my $nodes ( $wp->findnodes('./w:rPr/w:i'))
            {
                if ($set == 0)
                {
                    $styleTemp ->setType("italic");
                    $set = 1;
                }
                
            }
            foreach my $nodes ( $wp->findnodes('./w:rPr/w:b'))
            {
                if ($set == 0)
                {
                    $styleTemp ->setType("bold");
                    $set = 1;
                }
                else
                {
                    $styleTemp ->setType($styleTemp ->getType." bold");
                    $set = 1;
                }
            }
            foreach my $nodes ( $wp->findnodes('./w:rPr/w:u'))
            {
                if ($set == 0)
                {
                    $styleTemp ->setType("underlined");
                    $set = 1;
                }
                else
                {
                    $styleTemp ->setType($styleTemp ->getType." underlined");
                    $set = 1;
                }
            }

        }
        
      
    }
    #The styles are parsed correctly until here, there's an issue returning them properly.
    
#    say $styleTemp->getSize, $styleTemp->getColor, $styleTemp->getType, $styleTemp->getBasedOn;
    
    return $styleTemp;
}

sub parseFonts
{
    my %defFonts;
    my $path = shift;
    my $dom = XML::LibXML->load_xml(location => $path);
    
    #    say '$dom is a ', ref($dom);
    #    say '$dom->nodeName is: ', $dom->nodeName;
    
    my %hash;
    
    foreach my $fonts ($dom->findnodes('//w:font[1]'))
    {
        
        $defFonts{'Body'} = $fonts->getAttribute("w:name");
        
    }
    foreach my $fonts ($dom->findnodes('//w:font[3]'))
    {
        
        $defFonts{'Heading'} = $fonts->getAttribute("w:name");
        
    }
    
    return %defFonts;
}
    
sub parseDoc
{
    my $path = shift;
    my $dom = XML::LibXML->load_xml(location => $path);
    
#    say '$dom is a ', ref($dom);
#    say '$dom->nodeName is: ', $dom->nodeName;
    
    my @blockList;
    my $temp;
    my $styleTemp;
    my $returnedStyleTemp;
    
    foreach my $wp ($dom->findnodes('//w:p'))
    {
        $temp= Block->new(".0.",".0.",".0.",".0.", %defaultFonts);
        $styleTemp = Style->new(".0.",".0.",".0.",".0.",".0.", %defaultFonts);
        
        say "fonts in parse";
        say %defaultFonts;
        

        my $txt = "";
        foreach my $text  ($wp->findnodes('./w:r/w:t'))
        {
            $txt = $txt.$text->to_literal();
        }
        
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:pStyle'))
        {
            $temp ->setStyle_id( $nodes->getAttribute("w:val"));
            $returnedStyleTemp = parseStyles("styles.xml", $temp->getStyle_id);
            
            #Ok, the values here are also correct.
            
            $temp->setStyle($returnedStyleTemp);
            #Styles are also correct in temp after I set them.
        }
        
#        say "Before further changes ", $temp->getText, " ", $temp->getStyle_id, " returned font ", $temp->getStyle->getFont;
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:rFonts'))
        {
            $temp->getStyle->setFont( $nodes->getAttribute("w:ascii"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:color'))
        {
            $temp->getStyle->setColor( "#".$nodes->getAttribute("w:val"));
        }
        
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:sz'))
        {
            $temp->getStyle->setSize( $nodes->getAttribute("w:val"));
        }
        
        my $set = 0;
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:i'))
        {
            if ($set == 0)
            {
                $temp->getStyle->setType("italic");
                $set = 1;
            }
            
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:b'))
        {
            if ($set == 0)
            {
                $temp->getStyle->setType("bold");
                $set = 1;
            }
            else
            {
                $temp->getStyle->setType($temp->getStyle->getType." bold");
                $set = 1;
            }
        }
        foreach my $nodes ( $wp->findnodes('./w:pPr/w:rPr/w:u'))
        {
            if ($set == 0)
            {
                $temp->getStyle->setType("underlined");
                $set = 1;
            }
            else
            {
                $temp->getStyle->setType($temp->getStyle->getType." underlined");
                $set = 1;
            }
        }
        
#        say " After further changes: ", $temp->getText, " ",$temp->getStyle_id, " returned font", $temp->getStyle->getFont;
#
#        say "styletemp " , " returned color ", $styleTemp->getColor, " returned size ", $styleTemp->getSize;
    
        #THIS IS THE PROBLEM IT OVERRIDES EVERYTHING.
        
        $temp->setText( $txt);
#        $temp->setStyle($styleTemp);
        
        #Ok everything gets overrided above.
#        say " Nowwwwwwwwtemp: ", $temp->getStyle_id, " returned font ", $temp->getStyle->getFont;
#say " ";
        push(@blockList, $temp);

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
    unlink("styles.xml");
    unlink("font.xml");
}

#Generating

###########################################
# 			HTML (using HTML::Tiny)
###########################################

###################################################################################



sub HTMLgen
{
    my $html_potato = HTML::Tiny->new( mode =>'html' );
    my @blockList = @_;
    my $htmlList;
    my @htmlBody;
    my @htmlHead;
    my @htmlFoot;
    my $tomato;
    my $temp;
    
    my $tomato_potato;
    my @styleList ;
    my @defaultStyles;
    my @style_names = qw/Title Heading1 Heading2 Heading3 Heading4 Header Footer Normal Name/;
    
    #Pushing defaults
    
    foreach my $o (0.. $#style_names)
    {
        $tomato_potato = Style-> new (".0.", ".0.", ".0.", $style_names[$o], ".0.",          %defaultFonts);
        push (@defaultStyles, $tomato_potato);
    }
    
    # Getting styles
    my $count = 1;
    foreach my $k (0 .. $#blockList)
    {
        my $potato_temp = $blockList[$k]->getStyle();
        $potato_temp ->printStyle();
        if(check( $potato_temp, @defaultStyles))
        {
#            $potato_temp ->printStyle();
            $blockList[$k]->setStyle_type($count);
            $count ++;
            push(@styleList, $potato_temp);
        }
        else {
            $blockList[$k]->setStyle_type(0);
        }
    }
    
    #PARSING BLOCKLIST
    
    foreach my $i (@blockList)
    {
        my $temp = $i->getStyle_id();
        
        switch($temp)
        {
            case "Name"
            {
                if($i->getStyle_type() == 0){
                    push( @htmlHead , $html_potato->title($i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("title", {class => toClass($i) }, $i->getText()));
                }
                
            }
            case "Title"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlBody,  $html_potato->h1($i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("h1", {class => toClass($i) }, $i->getText()));
                }
            }
            case "Heading1"
            {
                if($i->getStyle_type() == 0){
                    push(@htmlBody ,  $html_potato->h2($i->getText()));
                }
                else
                {
                    push(@htmlHead, $html_potato->tag("h2", {class => toClass($i) }, $i->getText()));
                }
            }
            case "Heading2"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlBody ,  $html_potato->h3($i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("h3", {class => toClass($i) }, $i->getText()));
                }
            }
            case "Heading3"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlBody , $html_potato->h4($i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("h4", {class => toClass($i) }, $i->getText()));
                }
            }
            case "Header"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlHead, $html_potato->tag("header", $i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("header", {class => toClass($i) }, $i->getText()));
                    
                }
            }
            case "Footer"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlFoot, $html_potato->p( $i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("p", {class => toClass($i) }, $i->getText()));
                }
            }
            case "Normal"
            {
                if($i->getStyle_type() == 0){
                    push (@htmlBody, $html_potato->p($i->getText()));
                }
                else
                {
                    push (@htmlHead, $html_potato->tag("p", {class => toClass($i) }, $i->getText()));        		
                }
            }
            else {}
        }
    }
    # HTML HEADER
    
#    say $html_potato->tag ('link', { rel => 'stylesheet' }, { href => $filename.".css" });
    
    $temp = $htmlHead[0] ."\n".$html_potato->tag ('link', { rel => 'stylesheet' }, { href => $filename.".css" });
    
    if (defined($temp))
    {
        for my $k (1 .. $#htmlHead)
        {
            $temp = $temp."\n".$htmlHead[$k];
        }
        
        $htmlList = $htmlList . $html_potato->head (["\n".$temp."\n"]);
    }
    else { say "Error in initialization of Header\n"} ;
    
    # HTML BODY
    
    $temp = $htmlBody[0];
    
    if (defined($temp))
    {
        
        
        for my $j (1 .. $#htmlBody)
        {
            $temp = $temp."\n".$htmlBody[$j];
        }
        
        $htmlList = $htmlList . $html_potato->body (["\n".$temp]);
    }
    else { say "Error or no html body\n" };
    
    # HTML FOOTER
    
    $temp = $htmlFoot[0];
    
    if (defined($temp))
    {
        for my $l (1 .. $#htmlFoot)
        {
            $temp = $temp."\n".$htmlFoot[$l];
        }
        
        $tomato = $tomato . $html_potato->tag("footer",["\n".$temp]);
        
    }
    else { say "Error or no footer\n" };
    
    #PRINTING IN HTML FILE
    
    open( my $file, '>', $filename.'.html');
    
    print $file $html_potato->html(["\n".$htmlList, $tomato."\n"]);
    
    close $file;
    



###########################################
# 			CSS (Using CSS::Tiny)
###########################################

    my $css_potato = CSS::Tiny->new();

    # Updating css_potato
    my	$temp_potato;
    foreach my $j (@defaultStyles)
    {
        $temp_potato = Block -> new ($j->getBasedOn(), ".0.", $j, 0);
        $css_potato = toCSS ($temp_potato, $css_potato);
    }
    
    # Updating css_potato
    foreach my $k (@blockList)
    {
        $css_potato = toCSS ($k, $css_potato);
    }
    
    $css_potato->write($filename.".css");
}

sub check
{
    my ($potato_style, @list) = @_;
    foreach my $i (@list)
    {
        if ( $i->sameAs($potato_style) )
        {
            return 0;
        }
    }
    return 1;
}

sub toClass
{
    my $temp_block = shift;
    my $temp1 = $temp_block->getStyle_type();
    $temp1 = num2en($temp1);
    $temp1 =~ s/\s//g;
    return $temp1;

}

sub toCSS
{
#    $string =~ s/\s//g;
    my $tomato_block = shift;
    my $css = shift;
    my @properties = qw/color font/;
    #my @fontType = qw/h1 h2 h3 h4 p header/;
    my $temp = $tomato_block -> getStyle_id();
    my $temp1 = $tomato_block->getStyle_type();
    my $temp2 = num2en($temp1);
    $temp2 =~ s/\s//g;
    my $style = $tomato_block -> getStyle();
    
    switch ($temp)
    {
        case "Title"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{h1}->{color} = $style->getColor();
                $css->{h1}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor(),
                    font => $style->getType()." ".$style->getSize()."px ".$style->getFont()};
            }
        }
        case "Heading1"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{h2}->{color} = $style->getColor();
                $css->{h2}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor(), font => $style->getType()." ".$style->getSize()."px ".$style->getFont() };
            }
        }
        case "Heading2"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{h3}->{color} = $style->getColor();
                $css->{h3}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor(), font => $style->getType()." ".$style->getSize()."px ".$style->getFont()};
            }
        }
        case "Heading3"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{h4}->{color} = $style->getColor();
                $css->{h4}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor(), font => $style->getType()." ".$style->getSize()."px ".$style->getFont()};
            }
        }
        case "Header"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{header}->{color} = $style->getColor();
                $css->{header}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor() , font => $style->getType()." ".$style->getSize()."px ".$style->getFont() };
            }
        }
        case "Footer"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{'.footer'}->{color}  = $style->getColor();
                $css->{'.footer'}-> {font}  = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = { color =>$style->getColor(), font =>$style->getType()." ".$style->getSize()."px ".$style->getFont()};
            }
        }
        case "Normal"
        {
            if($tomato_block->getStyle_type() == 0)
            {
                $css->{p}->{color} = $style->getColor();
                $css->{p}->{font} = $style->getType()." ".$style->getSize()."px ".$style->getFont();
            }
            else
            {
                $css->{".".$temp2} = {color =>$style->getColor(), font => $style->getType()." ".$style->getSize()."px ".$style->getFont()};
            }
        }
        else {
            
        }
    }
    
    return $css;
}
