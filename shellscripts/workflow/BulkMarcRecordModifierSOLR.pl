#!/usr/bin/perl -w
# $Id$

# Script reads an MARCXML bulk export file from CBS with no newlines, 
# - adds '\n' after each "</record>"-tag
# - replaces German Umlaute which are stored in CBS decomposed 
# - writes the CBS record ID from conctrolfield 001 into a proper tag 'Docid'


use strict;
use Unicode::Normalize;

my $inFile = $ARGV[0];
open (IN, '<:utf8', "$inFile") or die "Can't read from $inFile: $!\n";

my $outFile= $ARGV[1];

# Explicitly open for utf-8 output:
open (OUT, '>:utf8', "$outFile") or die "Can't write to $outFile: $!\n";

$/ = "</record>";

while (<IN>) 
{
    #for SOLR the conversion into Docid (ID of the retrieval document) is done within the XSLT templates
    #which are responsible for document processing
	#s/(.*?)<controlfield tag="001">(.*?)<\/controlfield>(.*?)/$1<Docid>$2<\/Docid>$3/g;

	#s/\x41\xcc\x88/\xc3\x84/g;  #Ä
	#s/\x4f\xcc\x88/\xc3\x96/g;  #Ö
	#s/\x55\xcc\x88/\xc3\x9c/g;  #Ü
	#s/\x61\xcc\x88/\xc3\xa4/g;  #ä
	#s/\x6f\xcc\x88/\xc3\xb6/g;  #ö
	#s/\x75\xcc\x88/\xc3\xbc/g;  #ü

	# Convert decomposed characters to "canonical composition" normalization form (and print):
	#todo: GH this Normalization treatment could be done with JAVA (component PrdocumentProcessing)
	#for further details:
	#http://perldoc.perl.org/Unicode/Normalize.html (PERL)
	#http://weblogs.java.net/blog/joconner/archive/2007/02/normalization_c.html (Java)
    #then we can kick out this perl script
    #at the latest when we skip to SOLR (and FAST is going to be retired...)

	print OUT NFC($_) . "\n";
	
}

close IN;
close OUT;

exit(0)

