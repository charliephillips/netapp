#!/usr/bin/perl

open OUTPUT, '>', "output.txt" or die $!;
STDOUT->fdopen( \*OUTPUT, 'w' ) or die $!;

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
   $price = sprintf "%.2f", $price;
   my $change = $decoded_json->{'list'}{'resources'}[0]{'resource'}{'fields'}{'change'};
   $change = sprintf "%.2f", $change;
   printf("%-10s %-10s %-10s\n", $symbol, $price, $change);
}


