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

our %vers2 = ( cat => [
                      [ "meow","calico","cat food", 3 ],
                      [ "meow","kitkat","mouse",100 ],
                     ],
              dog => [
                      [ "ruff","bull","dog chow", 38 ],
                      [ "ruff","shepard","snacks", 57 ],
                      [ "ruff","elkhound","chicken", 87],
                     ],
              cow => [
                      [ "moo","stafford","corn", 88 ],
                      [ "moo","black","clover", 99 ],
                     ],              
);

my $pattern = "\*tv_cp_report__.csv";
my $pattern = "\*tv_cp_report__.txt";

my $event_number = 0;  
my %data;
#print Dumper \%vers;

my $ref = \%vers;

#print $ref->{dog}[0][3], "\n";
#print ${$ref}{dog}[0][3], "\n";
#print $#{$ref}{dog},"\n";
#print $#{@{$ref}{dog}},"\n\n";
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
my $ref = \%vers2;
sum_sub($ref);

#print Dumper \%data;
print "--------------------< start >----------------------\n";
my(@files) = get_file_list($pattern);
my $count = $#files + 1;
print "List of Files in \@files is: ", $count ,"\n";
foreach  my $ii ( 0 .. $#files ){
  chomp($files[$ii]);
  print "[$ii] $files[$ii]\n";
}
print "\n";
my $tagf = 0;
my $valf = 3;

open_array_of_files($tagf,$valf,@files);

print Dumper \%data;

# SUBS
#
sub open_array_of_files{
my($tagf,$valf,@list) = @_;
 foreach my $ii ( 0 .. $#list ){
    my $file = $list[$ii];
    print "opening: $file\n";
  open ( my $fh, '<' , $file) || die "Flaming death on open of $file: $?\n";
    my $line = $_;
    if( $line =~ m/(heading)/ig ) {
       next;
       print $1,"\n";
      }
    chomp($line);
    my @array = split(/,/,$line);
    my $tag = $array[$tagf];
    my $val = $array[$valf];
     push( @{ $data{$tag} }, "$ii"."_".$val );
 };
};

sub get_file_list{
my($pattern) = @_;
my $cmd = "/bin/ls ";
$cmd = $cmd."$pattern";
my @files = `$cmd`;
#print "List of report files:\n";
my @sorted = sort @files;
foreach my $item (@sorted){
  chomp($item);
 # print $item,"\n";
  }
return(@sorted);
};
 

sub get_date{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
$year += 1900;
#print $year,"\n";
$mon += 1;
#$year = sprintf("%02d", $year % 100);
$mday = sprintf("%02d", $mday);
my $date = $year."-".$mon."-".$mday;
return ($date);
};


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
       push( @{ $data{$key} }, "$event_number"."_".$ct );
       #$data{$key} = @[ $ct ];
       print "sum: $ct\n";
 };
       $event_number++;


};
