use strict;
use warnings;
use Data::Dumper;

my %HoA = ( 
          'XXX' => [
                     '0_163',
                     '1_324',
                     '2_497'
                   ],
          'ABC' => [
                     '0_79',
                     '1_166',
                     '2_252'
                   ],
          'AAA' => [
                     '0_51',
                     '1_118',
                     '2_185'
                   ],
          'ZZZ' => [
                     '1_67',
                     '2_135'
                   ]
       );

my $entry = "cat";
my $key = "ZZZ";
print $HoA{$key}[0],"\n";


print Dumper \%HoA;
