use strict;
use warnings;
use Data::Dumper;
use GD::Graph::linespoints;
use GD::Graph::lines;
use GD::Graph::hbars;


my @data = (
  [ '1st', '2nd', '3rd', '4th'],
  [ 45, 30, 20, 65],
  [ 23, 45, 70, 90],
  [ 25, 55, 74, 98],
  [ 80, 90, 91, 99]
);


my @array = qw ( 1st 2nd 3rd 4th);
my @data = ( [ @array ], 
  [ 45, 30, 20, 146],
  [ 23, 45, 70, 90],
  [ 25, 55, 74, 98],
  [ 80, 90, 91, 99]
);

#print Dumper \@data;

my @legend = ( 'ADS', 'JUD', 'DII', 'AHS');

print "------<  Start  >---------------------------------------\n";

my $lref = \@legend;
my $dref =\@data;


#graph_it($lref,$dref);

graph_it(\@legend,\@data);

print "------<  END  >-----------------------------------------\n";

sub graph_it{
my($legend,$gdata) = @_;
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
#$graph->set_legend('ADS', 'JUD', 'DII', 'AHS');
#my @legend = ( 'ADS', 'JUD', 'DII', 'AHS');
$graph->set_legend(@$legend);


my $gd = $graph->plot($gdata) or die $graph->error;

open(IMG, '>file2.png') or die $!;
binmode IMG;
print IMG $gd->png;
close IMG;

open(IMG, '>file2.gif') or die $!;
binmode IMG;
print IMG $gd->gif;
close IMG;

print "finished with graph creation!!!\n";

};


