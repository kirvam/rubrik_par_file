use strict;
use warnings;
use Data::Dumper;

my $pattern = "\*tv_cp_report__.csv";
my $pattern = "\*tv_cp_report__.txt";

my $event_number = 0;  
my %data;
my %table;

# my $ref = \%data;

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

my $href = open_array_of_files($tagf,$valf,@files);
#print Dumper \%table;

print "Print href\n";
print Dumper $href;

my $periods = $#files;
my($legendref,$gdataref) = read_thru_HoA($periods,$href);

my @legend = @$legendref;
my @gdata = @$gdataref;

print "Legend: \@legend\n";
print Dumper \@legend;

print "GDATA: \n";
print Dumper \@gdata;


graph_it(\@legend,\@gdata);



print "---------------------< end >------------------------\n";

# SUBS
#
sub read_thru_HoA{
# headings = number of events or files.  If there is no event for data there still needs to be value like 0_0 for event 1.
# data is table which needs to have 0 valuse inserted if there is no event so it can be graphed. 
my($periods,$href) = @_;
print "Number of periods: $periods\n";
my @periods;
foreach my $ii ( 0 .. $periods ){
       push @periods, $ii;
};
print Dumper \@periods;
my @legend = ();
my @gdata = ();;
#my @garray;
print "Printing \$ref_tab!!!\n";
foreach my $key ( sort keys %{$href} ){
     print "\$key: $key: \n";
        push @legend, $key;
       my @array =  @{ ${$href}{$key} };
        my @garray;
         foreach my $ii ( 0 .. $#array ){
                     print "$array[$ii]\n";
              push @garray, $array[$ii];       
                 }
           push @gdata, [ @garray ];
      #print "\$table{\$key}: $table{$key}\n";
 };
  unshift @gdata, [ @periods ];
  return(\@legend,\@gdata);
}

sub open_array_of_files{
my($tagf,$valf,@list) = @_;
my %data;
  print "\$tagf=$tagf\n\$valf=$valf\n";
    my $tag = ();
    my $val = (); 
 foreach my $ii ( 0 .. $#list ){
    my $file = $list[$ii];
    print "opening: $file\n";
  open ( my $fh, '<' , $file) || die "Flaming death on open of $file: $?\n";
    while(<$fh>){
    my $line = $_;
    chomp($line);
     print "\$line: $line\n";
    if( $line =~ m/(heading)/ig ) {
       next;
       print $1,"\n";
      }
    my @array = split(/,/,$line);
     $tag = $array[$tagf];
     $val = $array[$valf];
      my $entry = $array[$valf];
#     $data{$tag} += $array[$valf];
    $data{$tag}[$ii] = $entry;
###  push( @{ $data{$tag} }, "$ii"."_".$val );
   };
       print Dumper \%data;
    #foreach my $tag ( sort keys %data ){
    #  print "\$key: $tag\n";
    #   my $value = $data{$tag};
    #   $value = $ii."_".$value;
    #  push( @{ $table{$tag} }, $value );  
    #}; 
 } return(\%data);
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

sub graph_it{
my($legend,$data) = @_;
print "Dumping \$legend ref\n";
print Dumper \$legend;

print "Dumping \$data ref\n";
print Dumper \$data;

use GD::Graph::linespoints;
use GD::Graph::lines;
use GD::Graph::hbars;

my $graph = GD::Graph::linespoints->new(700, 600);

$graph->set(
    x_label           => 'Samples taken over Time',
    y_label           => 'GB\s Capacity Used on the Rubriks',
    title             => 'Rubrik Capacity Graph',
    y_max_value       => 200,
    y_tick_number     => 50,
    y_label_skip      => 5,

) or die $graph->error;

$graph->set_legend_font(GD::Font->Tiny);
$graph->set_legend(@$legend);

my $gd = $graph->plot($data) or die $graph->error;

open(IMG, '>RBK1.png') or die $!;
binmode IMG;
print IMG $gd->png;
close IMG;

open(IMG, '>RBK1.gif') or die $!;
binmode IMG;
print IMG $gd->gif;
close IMG;

print "finished with graph creation!!!\n";
};
