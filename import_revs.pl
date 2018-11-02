# importer.pl
use strict;
use warnings;
use Data::Dumper;
use revs;


print "---< start >---\n";
#print $revs::vers{foo} . "\n";
#print $revs::vers{'foo'} . "\n";
#print $revs::vers{'scooby'} . "\n";

print Dumper \%vers;

my $ref = \%vers;

print $ref->{foo} . "\n";
print $$ref{'scooby'}, "\n";


print "---< end >---\n";
