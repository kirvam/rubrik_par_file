use strict;
use warnings;
use Data::Dumper;
use mapper;

my $fields = 9; #there must be this many fields;
my $rep_fields = 3; # 3 actually 4...

my $cus_ref = \%customer_o_a;
#print Dumper \%customer_o_a;
#exit;

my $file = shift;
my %HoA;
my %gHoA;

# Headings for 4 colmns needed.
my @heading = (
'Tag',
'Object Name',
'SLA Domain',
'Total Local Storage(GB)',
);

print "--<start>------------------------------------------------\n";

my $date = get_date();
 print $date,"\n";
my @files = get_file_list();
my $num_files =$#files;


foreach my $kk ( 0 .. $#files ) {
print_fields($fields);
my($file,$headings) = parse_file($files[$kk]);
make_array_and_count($headings);
my $refHoA;
$refHoA = make_fields($file,$headings,\%HoA);

print "Dumper for \$refHoA\n";
print Dumper \$refHoA;
print_hash_ref($refHoA);

my $name = "SPX1";
my $name = "RBKT";

$name = $date."__".$name."_".$kk."_";

iterate_array($kk,$name,$refHoA,@heading);
};

print Dumper \%gHoA;

print "--<end>-------------------------------------------------\n";


#
# SUBS
#
###########################################################################33
sub get_date{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
$year += 1900;
#print $year,"\n";
$mon += 1;
$mday = sprintf("%02d", $mday);
my $date = $year."-".$mon."-".$mday;
return ($date);
};

sub get_file_list{
my @files = `/bin/ls *tv_cp_report__.csv`;
print "List of report files:\n";
foreach my $item (@files){
  chomp($item);
  print $item,"\n";
  }
return(@files);
};


sub iterate_array {
# sub to create tabs for each tag/key in HoA
# sub creates the following tabs:  TOTALS, SUMS (of the varios agencies/buckets), & A TAB for EACH AGENCY/BUCKET.
#
my($num_files,$name_for_sheet,$ref,@heading) = @_;
print "#### The number of files is \$num_files $num_files + 1. \n\n";
# Making %HoA to capture data for graphic.
use Excel::Writer::XLSX;
$name_for_sheet = $name_for_sheet."\.xlsx";
my $workbook = Excel::Writer::XLSX->new( $name_for_sheet );
print "---< Start iterate_array >---\n";
###
my @heading2 = qw ( TAG SUM );
my $sum_name = "SUMS";
my $worksheetsum = $workbook->add_worksheet( $sum_name );
  my $total_tab_start = 4;
  my $trow = 3;
 # my $ctrow = 3;
  my $new_c;
  my $srow = 2;
  my $scol = ();
 my $formath = $workbook->add_format();
      $formath->set_bold(1);
      $formath->set_align('left');
      $formath->set_bg_color('green');
      $formath->set_color('white');
      $formath->set_font('Tahoma');
      $formath->set_size('10');
 foreach my $ii ( 0 .. $#heading2 ){
                print "worksheetsum, write line: 2, $ii, $heading2[$ii]\n";
                $scol = $ii;
                $worksheetsum->write( $srow, $scol, $heading2[$ii], $formath  );
               };  

###
# Create TOTALS sheet.
my $totals = "TOTALS";
my $worksheettotal = $workbook->add_worksheet( $totals );
 # my $new_c;
 my $formath = $workbook->add_format();
      $formath->set_bold(1);
      $formath->set_align('left');
      $formath->set_bg_color('green');
      $formath->set_color('white');
      $formath->set_font('Tahoma');
      $formath->set_size('10');
         foreach my $ii ( 0 .. $#heading ){
           ###
           print "write line: 2, $ii, $heading[$ii]\n";
             $worksheettotal->write( 2, $ii, $heading[$ii], $formath  );
           ###
         };
  my $sum_counter =();
  my $sum_counter_total =();
foreach my $key ( sort ( keys %$ref ) ){
  print "$key:\n";
  $sum_counter = 0;
  if($key =~ m/Owner/gi){ print "### NEXT found Owner: $key.\n"; next; };
  ###if($key =~ m/eag/gi){ print "#### NEXT found Owner: $key.\n"; next; };
  if($key =~ m/vshield/gi){ print "#### NEXT found Owner: $key.\n"; next; };
  if($key =~ m/global/gi){ print "#### NEXT found Owner: $key.\n"; next; };
  # Object Name
  if($key =~ m/OBJ/gi){ print "#### NEXT found Owner: $key.\n"; next; };
###
  $srow++;
  $scol = 0;
  $worksheetsum->write( $srow, $scol, $key, $formath  );
  $scol++;
###
  
# Add a worksheet for each KEY, TAB for EACH AGENCY/BUCKET
   my $worksheet = $workbook->add_worksheet( $key );
   my $format = $workbook->add_format();
      $format->set_bold(1);
      $format->set_align('left');
      $format->set_bg_color('green');
      $format->set_color('white');
      $format->set_font('Tahoma');
      $format->set_size('10');
         print "write line: 0, 0, $key\n";
         $worksheet->write( 0, 0, $key, $format );
            foreach my $ii ( 0 .. $#heading ){
               ###
              print "write line: 2, $ii, $heading[$ii]\n";
               $worksheet->write( 2, $ii, $heading[$ii], $format  );
               ###
              };
# set row to start on row 2 to allow for header..
      my $col = 0; my $row = 3;
      #my $total_tab_start = $row; $total_tab_start++;
      my $start_col = $#heading; 
      my $start_row = $row+1;
      my $sum_start = "S".$start_row;  print "\$start_col: $start_col\n";   ###########  here...
      
       my $format1 = $workbook->add_format();
          $format1->set_bold(0);
          #$format1->set_bg_color(0);
          $format1->set_color(0);
          $format1->set_font( 'Tahoma' );
          $format1->set_size( '10' );

       foreach my $ii ( 0 .. $#{@{$ref}{$key}} ){
          my @array = @{ ${$ref}{$key}[$ii] } ;
             foreach my $jj ( 0 .. $#array ){
               #$col = $ii+2; # controls start of column
               ###
                 $col = $jj;
                  print "write line: $row, $col, $array[$jj]\n";
                    $worksheet->write( $row, $col, $array[$jj], $format1 );
                  print "write totals line: $trow, $col, $array[$jj]\n";
                    $worksheettotal->write( $trow, $col, $array[$jj], $format1 );
               ###
                   if( $jj eq 3 ){
                     $sum_counter += $array[$jj];
                    }
               ###
                    print "\t$ii,$jj: $array[$jj]\n";
               ###
              }
               ###
               ###
            $row++;
            $trow++;
       }
          $worksheetsum->write( $srow, $scol, $sum_counter, $format1  );
          $gHoA{$key}[$num_files] =  $sum_counter;
          $sum_counter_total += $sum_counter;
          
          my $final_row = $row;
          my $final_col = $start_col-1;
          my $sum_end = "D".$final_row;
          my $sum_start = "D".$start_row;
          my $vsum = "\=sum\($sum_start:$sum_end\)";
          my $vm_col = $final_col;
           print "write line: $row, $vm_col, $vsum\n";
  ###    
  ### TOTALS Label
          $vsum=~s/\=//g;
          my $tsum = "\=$vsum";

          my $t_col = $vm_col;
          $row = $row+2;
          print "write line: $row, $t_col, 'Total'\n";
  ###      $worksheet->write( $row, $t_col, 'Total', $format1 );
          my $t_col = $vm_col+1;
          print "write line: $row, $t_col, $tsum\n";
  ###  Totals SUM
          $worksheet->write( $row, $t_col, $tsum, $format1 );

  ###     Sets new column for ???
          $new_c = $col;
  ###     Here is wher to add the extra labels/products..
 };
        ### FOR TOTALS TAB
                 my $new_trow = $trow;  
                 my $sum_total_field = "=sum("."d".$total_tab_start.":"."d".$new_trow.")";  print $sum_total_field, "\n";
                 print "write final totals sum cell: $trow, $new_c, $sum_total_field\n";
                 #$worksheettotal->write( $trow, $new_c, $sum_total_field, $format1 );
                 $worksheettotal->write( $trow, $new_c, $sum_total_field );
                 $srow++;
                 $worksheetsum->write( $srow, $scol, $sum_counter_total  );
    
print "---< End iterate_array >-----\n";
};

###
sub print_hash_ref {
# sub to print HoA
my($ref) = @_;
print "\n\n---< Start print_hash_ref Sub >-----\n";
 foreach my $key ( sort ( keys %$ref ) ){
      print "$key:\n";
       foreach my $ii ( 0 .. $#{@{$ref}{$key} } ){
             my @array = @{ ${$ref}{$key}[$ii] } ;    
            #foreach my $jj ( 0 .. $#{ @{$ref}{$key}[$ii] } ){
                 if($#array < $rep_fields){ 
                    print "#### LESS than $rep_fields\n";
                   } else {
                     print "field placemnt correct, $rep_fields.\n";
                      };
                foreach my $jj ( 0 .. $#array ){
                     print "\t$ii,$jj: $array[$jj]\n";
                      };
               ### print "\t$ii: ${$ref}{$key}[$ii][$jj]\n";
       };
 };
print "---< End print_hash_ref Sub >-----\n";
};

sub print_fields {
my($fields) = @_;
print "There needs to be: $fields.\n";
};

sub make_array_and_count{
print "\n---make_array_and_count---\n";
# $array should be split by comma,",".
my($headings) = @_;
my @headings = split(/,/,$headings);
print "\nNumber of Headings:\n";
for my $ii ( 0 .. $#headings ){
     print "$headings[$ii] [$ii ++ 1]\n";
 }
};

sub make_fields{
print "\n----------make-fields---------\n";
my($file,$headings,$refHoA) = @_;
my @headings = split(/,/,$headings);
open ( my $fh, "<", $file ) || die "Flaming death on open: $!";
while (<$fh>){
my $line = $_;
chomp($line);
my @line = split(/,/,$line);
my @array;
print "\n";
for my $ii ( 0 .. $#headings ){
     #print "\$ii: $ii\n";
     if( ! $line[$ii] ){ #print "Found NO VAL.\n"; 
        $line[$ii] = "0";
    } 
###
     my $val = $line [$ii];
     $val =~ s/\r//;
     $val =~ s/\"//g;
###    
###    push @array, $line [$ii];
       push @array, $val;
     #print "$headings[$ii] => $line[$ii]\n";
  }
   # if( $array[5] eq "0" ){ print "--FOUND NO OWNER, $array[0]\n";
   #      if ( $array[0] =~ m/^(\w{3,})/g ){
   #           $array[5] = $1;
   #            print "--$1\n";
   #          } else {
   #              print "--CST\n";      
   #              $array[5] = "CST";
   #     }
  #}
     for my $ii ( 0 .. $#array){
         print "$headings[$ii]=>$array[$ii]\n";
    }
   my $owner = $array[0];
   my $org =();
     ###
     ###      if ( $owner =~ m/^(\d{3,4})\-*/ig ){
#        if ( $customer_o_a{$owner}){
        if ( $cus_ref->{$owner}){

           # check table for odd-balls
           #
           $org = $cus_ref->{$owner};
           print "#### FOUND PDD-BALL: $cus_ref->{$owner}\n";
         } 
        elsif ( $owner =~ m/^(\w{3,4}\-.+)/ig ) {
                my $match = $1;
                print "#### MATCH: $match\n";
                my @match = split(/-/,$owner);
                $org = $match[0];
                print "#### Org is $org\n";
          } else {
            print "#### NO MATCH\n";
            $org = substr $owner, 0, 3;
            print "#### $org\n";
      };
     
  $org = uc( $org );
     if ( $cus_ref->{$org} ){
          print "#### Found \$org in Cus Table. \n";
          $org = $cus_ref->{$org};
       };
  my @arr =();
  if( $array[0] =~ m/^(All)$/i ){
   ## Attemp to manage NAS in one spot
   @arr = ( $org, $array[2], $array[4], $array[6] );
   } else {
   @arr = ( $org, $array[0], $array[4], $array[6] );
 };
###

   if(${$refHoA}{$org}){
#          push @{ $refHoA->{$owner} }, [ @array ];
           push @{ $refHoA->{$org} }, [ @arr ];
      }  
    else {
#       @{ $refHoA->{$owner} } = [ @array ];
        @{ $refHoA->{$org} } = [ @arr ];

       }
#     print Dumper \$refHoA;
 }
close $fh;
return ($refHoA);
};

sub parse_file {
my($file) = @_;
my $ii = 0;
my $jj = 0;
my $headings;
open ( my $fh, "<", $file ) || die "Flaming death on open: $!";
while (<$fh>){
$ii++;
my $line = $_;
chomp($line);
if ($ii eq 1){ $headings = $line;
    print $headings,"\n";
    };
my @array = split(/,/,$line);
#print Dumper \@array;
my $count = $#array;
print "count: $count\n";
$jj++;
 }
close $fh;
print "Here are the headings:\n$headings\n";
print "Total lines: $jj\n";
return($file,$headings);
};
