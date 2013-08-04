#!/usr/bin/perl -w
# $Id$

# Script reads an MARCXML bulk export file from CBS with no newlines, 
# - adds '\n' after each "</record>"-tag
# - replaces German Umlaute which are stored in CBS decomposed 


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
	#print OUT NFC($_) . "\n";
	print OUT $_ . "\n";

}

close IN;
close OUT;

exit(0)

