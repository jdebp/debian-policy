## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/LaTeX: SGML conversion specification for LaTeX output format
## ----------------------------------------------------------------------
## Copyright (C) 1998-2001 Ardo van Rangelrooij
## Copyright (C) 1997 Christian Leutloff
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::LaTeX;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## import packages
use SGMLS::Output;

## ----------------------------------------------------------------------
## paper size definitions
my @paper = split( /\s/, `2>/dev/null paperconf -N` );
my $pagespec = "A4";
if ( $#paper > -1 )
{
    if ( $paper[0] =~ m/[ABC][0-9]/ )
    {
	$pagespec = $paper[0];
    }
    elsif ( $paper[0] =~ m/[letter|legal|executive]/ )
    {
	$paper[0] =~ tr/A-Z/a-z/;
	$pagespec = "US" . $paper[0];
    }
}

## ----------------------------------------------------------------------
## layout definitions
$DebianDoc_SGML::Format::Driver::indent_level = 1;

## ----------------------------------------------------------------------
## global variables
use vars qw( $set_appendix $set_arabic );

## ----------------------------------------------------------------------
## book output subroutines
## ----------------------------------------------------------------------
sub _output_start_book
{
    my $babel = $DebianDoc_SGML::Format::Driver::i18n{'babel'};
    output( "\\documentclass[11pt,$babel]{book}\n" );
    output( "\\usepackage{t1enc}\n" );
    output( "\\usepackage[$DebianDoc_SGML::Format::Driver::i18n{'inputenc'}]{inputenc}\n" )
	if length( $DebianDoc_SGML::Format::Driver::i18n{'inputenc'} );
    output( "\\usepackage{babel}\n" );
    output( "\n" );
    output( "\\usepackage{helvet}\n" );
    ## NOTE: below is a temporary solution !!!!!!!!!
    output( "\\usepackage{times}\n" )
	if $DebianDoc_SGML::Format::Driver::i18n{ 'inputenc' } ne 'latin2';
    output( "\n" );
    output( "\\usepackage{vmargin}\n" );
    output( "\\setpapersize{$pagespec}\n" );
    output( "\\setmarginsrb{25.4mm}{25.4mm}{25.4mm}{25.4mm}{15pt}{11mm}{0pt}{11mm}\n" );
    output( "\n" );
    output( "\\usepackage{fancyhdr}\n" );
    output( "\\pagestyle{fancy}\n" );
    output( "\\renewcommand{\\chaptermark}[1]{%\n" );
    output( "\\markboth{\\chaptername\\ \\thechapter.\\ #1}{}}\n" );
    output( "\\lhead{\\leftmark}\n" );
    output( "\\chead{}\n" );
    output( "\\rhead{\\thepage}\n" );
    output( "\\lfoot{}\n" );
    output( "\\cfoot{}\n" );
    output( "\\rfoot{}\n" );
    output( "\\renewcommand{\\headrulewidth}{0.4pt}\n" );
    output( "\\renewcommand{\\footrulewidth}{0pt}\n" );
    output( "\\fancypagestyle{plain}{%\n" );
    output( "\\lhead{}\n" );
    output( "\\chead{}\n" );
    output( "\\rhead{\\thepage}\n" );
    output( "\\lfoot{}\n" );
    output( "\\cfoot{}\n" );
    output( "\\rfoot{}\n" );
    output( "\\renewcommand{\\headrulewidth}{0.4pt}\n" );
    output( "\\renewcommand{\\footrulewidth}{0pt}}\n" );
    output( "\n" );
    output( "\\usepackage{paralist}" );
    output( "\\usepackage{alltt}\n" );
    output( "\n" );
    output( "\\usepackage[multiple]{footmisc}\n" );
    output( "\\usepackage{url}\n" );
    output( "\\usepackage{varioref}\n" );
    output( "\\vrefwarning\n" );
    output( "\\usepackage{hyperref}\n" );
    output( "\n" );
    output( "\\parindent=0pt\n" );
    output( "\\setlength{\\parskip}{%\n" );
    output( "0.5\\baselineskip plus0.1\\baselineskip minus0.1\\baselineskip}\n" );
    output( "\n" );
    output( "\\begin{document}\n" );
}
sub _output_end_book
{
    output( "\n" );
    output( "\\end{document}\n");
    output( "\n" );
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
    output( "\n" );
    output( "\\begin{titlepage}\n" );
    output( "\n" );
    output( "\\thispagestyle{empty}\n" );
    output( "\n" );
    output( "\\begin{center}\n" );
    output( "{\\Huge \\vspace*{2ex} $DebianDoc_SGML::Format::Driver::title \\\\[2ex]}\n" );
    grep( output( "{\\large $_ } \\\\\n" ), @DebianDoc_SGML::Format::Driver::authors );
    output( "\\vspace*{1ex} $DebianDoc_SGML::Format::Driver::version \\\\\n" )
	if length( $DebianDoc_SGML::Format::Driver::version );
    output( "\\end{center}\n" ); 
    if ( length( $DebianDoc_SGML::Format::Driver::abstract ) )
    {
	output( "\n" );
	output( "\\vspace*{1ex}\n" );
	output( "\\begin{center}\n" );
	output( "\\section*{$DebianDoc_SGML::Format::Driver::i18n{ 'abstract' }}\n" );
	output( "\\end{center}\n" ); 
	output( "$DebianDoc_SGML::Format::Driver::abstract\n" );
    }
    if ( length($DebianDoc_SGML::Format::Driver::copyright ) )
    {
	output( "\n" );
	output( "\\newpage\n" );
	output( "\n" );
	output( "\\thispagestyle{empty}\n" );
	output( "\n" );
	output( "\\vspace*{1ex}\n" );
	output( "\\vfill\n" );
	output( "\\section*{$DebianDoc_SGML::Format::Driver::i18n{ 'copyright notice' }}\n" );
	output( "\n" );
	output( "$DebianDoc_SGML::Format::Driver::copyright\n" );
    }
    output( "\n" );
    output( "\\end{titlepage}\n" ); 
}
sub _output_copyrightsummaries
{
    output( join( " \\\\\n", @_ ), "\n" );
}

## ----------------------------------------------------------------------
## table of contents output subroutines
## ----------------------------------------------------------------------
sub _output_toc
{
    output( "\n" );
    output( "\\pagenumbering{roman}\n" );
    output( "\\tableofcontents\n" );
}
sub _output_tocentry
{
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
sub _output_chapter
{
    output( $_[0] );
}
sub _output_appendix
{
    output( $_[0] );
}
sub _output_heading
{
    if ( $_[1] == -2 && ! $set_appendix )
    {
	$set_appendix = 1;
	output( "\n" );
	output( "\\appendix\n" );
    }
    output( "\n" );
    if ( $_[1] < 0 )
    {
	output( "\\chapter" );
    }
    elsif ( $_[1] == 0 )
    {
	output( "\\section" );
    }
    elsif ( $_[1] == 1 )
    {
	output( "\\subsection" );
    }
    elsif ( $_[1] == 2 )
    {
	output( "\\subsubsection" );
    }
    elsif ( $_[1] == 3 )
    {
	output( "\\paragraph" );
    }
    else
    {
	output( "\\subparagraph" );
    }
    output( "{$_[0]}\n" );
    output( "\\label{$_[3]}\n" ) if length( $_[3] );
    if ( ! $set_arabic )
    {
	$set_arabic = 1;
	output( "\\pagenumbering{arabic}\n" );
    }
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( length( $_[0] ) )
    {
	# Before a new paragraph and after a non-compact example
	output( "\n" )
	    if ! $DebianDoc_SGML::Format::Driver::is_compact
		&& ! $DebianDoc_SGML::Format::Driver::was_compact;
	$_[0] =~ s/^\s+//gm;      # remove leading spaces
	$_[0] =~ s/\n\n+/\n/g;    # no blank lines in paragraphs
	output( "$_[0]\n" );
    }
    else
    {
	# This puts a newline between adjacent specials, which doesn't
	# do anything, but more importantly ensures that there is a
	# newline before a paragraph which begins with a compact special
	output( "\n" )
	    if ( $DebianDoc_SGML::Format::Driver::is_special
		 && ! $DebianDoc_SGML::Format::Driver::is_compact
		 && $DebianDoc_SGML::Format::Driver::will_be_compact );
    }

    # The logic here is a bit hairy.  Basically, we only change the
    # \parskip setting if the following is the case:
    #  set to >0 if we're not currently compact, but we're coming out
    #               of a compact state, but we're not about to enter
    #               one again
    if ( ! $DebianDoc_SGML::Format::Driver::is_compact &&
	 $DebianDoc_SGML::Format::Driver::was_compact &&
	 ( ( $DebianDoc_SGML::Format::Driver::is_special &&
	     ! $DebianDoc_SGML::Format::Driver::will_be_compact) ||
	   ! $DebianDoc_SGML::Format::Driver::is_special ) )
    {
	output( "\\setlength{\\parskip}{%\n" );
	output( "0.5\\baselineskip plus0.1\\baselineskip minus0.1\\baselineskip}\n" );
    }
    # and set to 0 if we're about to enter a compact state, but we aren't
    #                 currently compact or leaving a compact state
    if ( $DebianDoc_SGML::Format::Driver::is_special &&
	 $DebianDoc_SGML::Format::Driver::will_be_compact &&
	 ! $DebianDoc_SGML::Format::Driver::is_compact &&
	 ! $DebianDoc_SGML::Format::Driver::was_compact )
    {
	output( "\\setlength{\\parskip}{0ex}\n" );
    }
}

## ----------------------------------------------------------------------
## example output subroutines
## ----------------------------------------------------------------------
sub _output_example
{
    my $space = $DebianDoc_SGML::Format::Driver::indent_level > 0 ?
        "  " x $DebianDoc_SGML::Format::Driver::indent_level : "    ";
    $_[0] = " $space" . $_[0];
    $_[0] =~ s/\n/\n $space/g;
    $_[0] =~ s/\s+$/\n/;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\\begin{alltt}\n" );
    output( $_[0] );
    output( "\\end{alltt}\n" );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnote
{
    output( "\\footnote{$_[0]}" );
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub _output_comment
{
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub _output_list
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactitem}\n" : "\\begin{itemize}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactitem}\n" : "\\end{itemize}\n" );
}
sub _output_enumlist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactenum}\n" : "\\begin{enumerate}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactenum}\n" : "\\end{enumerate}\n" );
}
sub _output_taglist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactdesc}\n" : "\\begin{description}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactdesc}\n" : "\\end{description}\n" );
}
sub _output_list_tag
{
}
sub _output_enumlist_tag
{
}
sub _output_taglist_tag
{
}
sub _output_list_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\\item\n" );
    output( $_[0] );
}
sub _output_enumlist_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\\item\n" );
    output( $_[0] );
}
sub _output_taglist_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    foreach ( @{$_[1]} )
    {
        output( "\\item[$_]\n" );
    }
    output( "$_[0]" );
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "\\textit{$_[0]}" );
}
sub _output_strong
{
    output( "\\textbf{$_[0]}" );
}
sub _output_var
{
    output( "\\textit{$_[0]}" );
}
sub _output_package
{
    output( "\\texttt{$_[0]}" );
}
sub _output_prgn
{
    output( "\\texttt{$_[0]}" );
}
sub _output_file
{
    output( "\\path{$_[0]}" );
}
sub _output_tt
{
    # Double dashes should be written as --- to get a double dash in
    # the font.  Strange or what?
    $_[0] =~ s/--/---/g;
    output( "\\texttt{$_[0]}" );
}
sub _output_qref
{
    output( $_[0] );
}

## ----------------------------------------------------------------------
## xref output subroutines
## ----------------------------------------------------------------------
sub _output_ref
{
    output( "`$_[0]' \\vpageref{$_[3]}" );
}
sub _output_manref
{
    output( "\\texttt{" );
    output( _sani( $_[0] ) );
    output( "($_[1])}" );
}
sub _output_email
{
    output( ' ' ) if ( $DebianDoc_SGML::Format::Driver::in_author );
    output( "\\texttt{<$_[0]>}" );
}
sub _output_ftpsite
{
    output( "\\url{$_[0]}" );
}
sub _output_ftppath
{
    output( "\\path{$_[1]}" );
}
sub _output_httpsite
{
    output( "\\url{$_[0]}" );
}
sub _output_httppath
{
    output( "\\path{$_[1]}" );
}
sub _output_url
{
    output( _sani( $_[1] ) ) if $_[1] ne "";
    output( " (" ) if $_[1] ne "";
    output( "\\path{" );
    output( $_[0] );
    output( "}" );
    output( ")" ) if $_[1] ne "";
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _cdata
{
    output( _sani( $_[0] ) );
}
sub _sdata
{
    output( $DebianDoc_SGML::Format::Driver::sdata_mapping{ $_[0] } )
	if defined( $DebianDoc_SGML::Format::Driver::sdata_mapping{ $_[0] } );
}
sub _sani
{
    ( $_ ) = @_;

    # replace backslash character
    s/\\/\\(\\backslash\\)/g;

    # escape command characters
    s/{/\\{/g;
    s/}/\\}/g;
    s/\$/\\\$/g;

    # escape command characters
    s/_/\\_/g;
    s/&/\\&/g;
    s/\#/\\\#/g;
    s/\%/\\\%/g;
    s/\^/\\^{}/g;
    s/~/\\~{}/g;

    # no further replacement in examples
    return $_ if $DebianDoc_SGML::Format::Driver::is_example;

# Don't want this to happen; we can use &ndash; and &mdash if we
# really want dashes.
#    # hyphens
#    s/-/--/g;
#    s/----/---/g;

    # quotes
    s/\"(.*?)\"/\`\`$1\'\'/g;

    # dots should be ellipsis "..."
    s/\.\.\./\\dots /g;

    return $_;
}

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
