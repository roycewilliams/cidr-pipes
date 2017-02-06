#!/usr/bin/perl -Tw
#-----------------------------------------------------------------------
# Name: ipdivide.pl
# Created: 2014-04-16
# Author: Royce Williams
# Purpose: Split subnets into smaller subnets of a specific size.
# $Id: ipdivide.pl,v 1.2 2014/06/23 22:55:13 royce Exp royce $
#-----------------------------------------------------------------------

use strict;
use warnings;

use Getopt::Std;
use NetAddr::IP;

#-----------------------------------------------------------------------

my $split_length = 28;
my @addresses;

our($opt_n);

#-----------------------------------------------------------------------
# Process cmd line.

getopt('n:');

if ($opt_n) {
    $split_length = $opt_n;
#    print STDERR "Will divide into /" . $opt_n . " chunks.\n";
}

#-----------------------------------------------------------------------

my @addresses_raw = (<STDIN>);

# Rough filter for non-IP records.
my @addresses_raw2 = grep /^[0-9]/, @addresses_raw;

# Create network objects for each record.
push @addresses, NetAddr::IP->new($_) for @addresses_raw2;

foreach my $network (@addresses) {
    my @splitnet = NetAddr::IP->new("$network")->split($split_length);
    print join ("\n", @splitnet), "\n";
}

#-----------------------------------------------------------------------

