#!/usr/bin/perl -Tw
#-----------------------------------------------------------------------
# Name: ipmerge.pl
# Created: 2014-04-16
# Authors: Royce Williams, Leif Sawyer
# Purpose: combine subnets into largest possible contiguous blocks.
#-----------------------------------------------------------------------

use strict;
use warnings;

use NetAddr::IP qw(Compact);

#-----------------------------------------------------------------------

my @addresses;
my @addresses_raw;

# Rough filter for non-IPv4 records.
while (<STDIN>) {
    if (m/^((?:\d{1,3}\.){3}\d{1,3}(?:\/\d{1,2})?)(.*)$/) {
        push @addresses_raw, $1;
    }
}

# Create network objects for each record.
push @addresses, NetAddr::IP->new($_) for @addresses_raw;

# Print output.
print join("\n", Compact(@addresses)), "\n";

#-----------------------------------------------------------------------

