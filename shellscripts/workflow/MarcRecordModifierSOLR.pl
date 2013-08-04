#!/usr/bin/perl

use strict;
use Unicode::Normalize;

my $inFile = $ARGV[0];
open (IN, '<:utf8', "$inFile") or die "Can't read from $inFile: $!\n";

my $outFile= $ARGV[1];
open (OUT, '>:utf8', "$outFile") or die "Can't write to $outFile: $!\n";

$/ = "</soap:Envelope>";

	print OUT "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
	print OUT "<collection>\n";
	
while (<IN>) 
{

	s/[\n\r]/ /g;	
	
	s/<\/?soap:Envelope.*?>//g;
	s/<\/?soap:Header.?>//g;
	s/<\/?soap:Body>//g;	
	
	s/<\/?ucp:updateRequest.*?>//g;	
	
	s/<srw:version.*<\/srw:version>//g;			
	s/<ucp:action.*<\/ucp:action>//g;	
	s/<ucp:recordIdentifier.*<\/ucp:recordIdentifier>//g;	
	s/<srw:record>//g;	
	s/<\/srw:record>//g;	
	s/<srw:recordPacking.*<\/srw:recordPacking>//g;	
	s/<srw:recordSchema.*<\/srw:recordSchema>//g;	
	s/<\/?srw:recordData>//g;	
	s/<mx:record.*?>/<record>/g;	
	s/<\/mx:record>/<\/record>/g;	
	s/(<\/?)mx:/$1/g;
	
#	s/(.*?)<controlfield tag="001">(.*?)<\/controlfield>(.*?)/$1<Docid>$2<\/Docid>$3/g;

#	s/\x41\xcc\x88/\xc3\x84/g;  #Ä
#	s/\x4f\xcc\x88/\xc3\x96/g;  #Ö
#	s/\x55\xcc\x88/\xc3\x9c/g;  #Ü
#	s/\x61\xcc\x88/\xc3\xa4/g;  #ä
#	s/\x6f\xcc\x88/\xc3\xb6/g;  #ö
#	s/\x75\xcc\x88/\xc3\xbc/g;  #ü
	
	print OUT NFC($_) . "\n";	
}

	print OUT "</collection>";

close IN;
close OUT;

exit(0)

