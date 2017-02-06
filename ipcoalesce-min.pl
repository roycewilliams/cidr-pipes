#!/usr/bin/perl -Tw

use strict;
use warnings;

use Getopt::Std;
use NetAddr::IP;

my $split_length = 28;
my @addresses;

our($opt_n);

#-----------------------------------------------------------------------
# Process cmd line.

getopt('n:');

if ($opt_n) {
    $split_length = $opt_n;
    print STDERR "Will divide into /" . $opt_n . " chunks.\n";
}

#-----------------------------------------------------------------------

my @addresses_raw2 = grep /^[0-9]/, (<STDIN>);

# Rough filter for non-IP records.
#my @addresses_raw2 = grep /^[0-9]/, @addresses_raw;

# Create network objects for each record.
push @addresses, NetAddr::IP->new($_) for @addresses_raw2;

print join("\n", @{NetAddr::IP::coalesce($split_length, 1, @addresses)}), "\n";

#-----------------------------------------------------------------------

