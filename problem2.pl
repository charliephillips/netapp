#!/usr/bin/perl

use LWP::Simple;
use JSON qw( decode_json );

open(FILE, $ARGV[0]) or die "Couldn't open file $ARGV[0], $!";

while(<FILE>){
   my $symbol = $_;
   chomp $symbol;
   my $url = "http://finance.yahoo.com/webservice/v1/symbols/$symbol/quote?format=json&view=detail";
   my $response = get( $url );
   die 'Error getting $url' unless defined $response;

   my $decoded_json = decode_json( $response );
   my $price = $decoded_json->{'list'}{'resources'}[0]{'resource'}{'fields'}{'price'};
   my $change = $decoded_json->{'list'}{'resources'}[0]{'resource'}{'fields'}{'change'};
   print "$symbol $price $change\n";   
}


