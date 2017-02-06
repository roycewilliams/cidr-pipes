#!/usr/bin/perl -Tw
#-----------------------------------------------------------------------
# Name: range2cidr.pl
# Created: 2014-04-16
# Author: Royce Williams
# Purpose: Convert ranges to CIDR
# $Id: range2cidr.pl,v 1.1 2014/06/24 00:48:31 royce Exp royce $
#-----------------------------------------------------------------------
use strict;
use warnings;

use Getopt::Std;
#use NetAddr::IP qw( Compact Coalesce Zeros Ones V4mask V4net netlimit );
use NetAddr::IP qw( Coalesce ); 

use lib '/home/royce/lib/perl';
#use Net::CIDR::Lite;
use Net::CIDR;

my $address_list_file;
my $network_list_file;

my @addresses_raw;
my @addresses;
my @networks_raw;
my @networks;

use vars qw($opt_a $opt_i $opt_n $opt_x);

#-----------------------------------------------------------------------
# Process input files.

#print @addresses_raw;
#print @networks_raw;

#print @addresses;
#print @networks;

#print STDERR "- Processing networks ";

# Create network objects for each address.
push @addresses, new NetAddr::IP ($_) for @addresses_raw;

# Create network objects for each record.
while (<>) {
    # Crude check for range of IPs - convert to CIDR first.
    next unless /^[0-9]/;
    if ($_ =~ /\-/) {
        push @networks, Net::CIDR::range2cidr("$_");
        push @networks, Net::CIDR::range2cidr("$_");
        print STDERR '-';
    } else {
        push @networks, new NetAddr::IP ($_);
        print STDERR '.';
    }
}
print STDERR "\n";

foreach my $network_item (@networks) {
	print ("$network_item\n");
}
#print @addresses;

print "\n";

#push @networks,  new NetAddr::IP ($_) for @networks_raw;

#-----------------------------------------------------------------------
# Compare.

print join("\n", @{NetAddr::IP::coalesce($network_list_file,1,@addresses)}), "\n";

#-----------------------------------------------------------------------

