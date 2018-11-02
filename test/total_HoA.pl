use strict;
use warnings;
use Data::Dumper;

our %vers = ( cat => [ 
                      [ "meow","calico","cat food", 3 ],
                      [ "meow","kitkat","mouse",100 ],
                     ],
              dog => [
                      [ "ruff","bull","dog chow", 33 ],
                      [ "ruff","shepard","snacks", 55 ],
                      [ "ruff","elkhound","chicken", 77],
                     ]
);
  
print Dumper \%vers;

my $ref = \%vers;

print $ref->{dog}[0][3], "\n";
print ${$ref}{dog}[0][3], "\n";
#print $#{$ref}{dog},"\n";
print $#{@{$ref}{dog}},"\n\n";
#print $#{ @{$ref}{dog}[1] }, "\n";

my $cc =();
my $tc =();
print "--< \$ref >---\n";
foreach my $key ( keys %{ $ref } ) {
       $cc = 0;
       print "\$key: ";
       print $key,"\n";
     foreach my $ii ( 0 .. $#{ @{$ref}{$key} } ){ 
      my @array = @{  ${$ref}{$key}[$ii] };
       foreach my $jj ( 0 .. $#array ){
        print "  ";
        print "[$ii][$jj]: ",$array[$jj];
        if ($jj eq 3){
          $cc += $array[$jj];
          $tc += $array[$jj];
         }
     }
        print "\n";
  }
        print "II: $cc\n";
};
        print "TC: $tc\n";


print "\n\n---Running sub!\n";
sum_sub($ref);


# SUBS
#
sub sum_sub {
my($ref) = @_;
my $ct =();
foreach my $key ( keys %{ $ref } ) {
       print "\$key: ";
       print $key,"| ";
     foreach my $ii ( 0 .. $#{ @{$ref}{$key} } ){
      my @array = @{  ${$ref}{$key}[$ii] };
       foreach my $jj ( 0 .. $#array ){
        #print "  ";
        #print "[$ii][$jj]: ",$array[$jj],"\n";
        # grab the 3rd value
        if( $jj eq 3 ){
        $ct += $array[$jj];
        }
    }
   }
       print "sum: $ct\n";
 };
};
