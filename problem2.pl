#!/usr/bin/perl

use LWP::Simple;

open(FILE, $ARGV[0]) or die "Couldn't open file $ARGV[0], $!";

while(<FILE>){
#   print "$_";
   my $symbol = $_;
   chomp $symbol;
   my $url = "http://finance.yahoo.com/webservice/v1/symbols/$symbol/quote?format=json&view=detail";
   my $response = get $url;
   die 'Error getting $url' unless defined $response;
#   print "$response";
   my $price = 1;
   my $change = 2;
   print "$symbol $price $change\n";   
}


