# Word to Web

LICENSE GPL © Copyright 2016

Contributors:
Alia Hassan, Ingy Nazif, and Shehab Abdel-Salam
The American University in Cairo.

Intro

This is a script that takes a Word document file as input (.docx) and parses the main elements to generate the corresponding .html and .css files.


User Guide


Dependencies

    Switch
    Lingua::EN::Numbers
    HTML::Tiny
    CSS::Tiny
    IO::Uncompress::Unzip
    XML::LibXML

How to use:
    
    1. Make sure the folders included in the repository as well as the document you would like to convert are in the same folder as the main.pl script.
    2. Open the Terminal.
    3. Run the script by supplying the filename of the Word Document (include the .docx).
    4. Watch the magic happen!
    5. The generated files will be located in the current folder with the names filename.html and filename.css

The features supported by this script are:
    - Header & Footer
    - All Word Document Styles
    - All Word Document Themes
    - Colors, Size, Font and Type Customization

The current version of this script does not yet support the following:
    - Hyperlinks
    - Indentation
    - Images