#!/usr/bin/perl -Tw
#-----------------------------------------------------------------------
# Name: ipsift.pl
# Created: 2014-04-16
# Author: Royce Williams
# Purpose: Show if an IP is in a netblock [PENDING]
# $Id: ipsift.pl,v 1.1 2014/06/24 00:48:31 royce Exp royce $
#-----------------------------------------------------------------------
# TODO
# Teach sifter to understand dash-separated ranges and convert.
#   First, detect them.
#-----------------------------------------------------------------------

print "\n\n\nWARNING - not yet completed.\n\n\n";

use strict;
use warnings;

use Getopt::Std;
use NetAddr::IP qw( Compact Coalesce Zeros Ones V4mask V4net netlimit );

use lib '/home/royce/lib/perl';
use Net::CIDR;

my $address_list_file;
my $network_list_file;

my @addresses_raw;
my @addresses;
my @networks_raw;
my @networks;

use vars qw($opt_a $opt_i $opt_n $opt_x);

#-----------------------------------------------------------------------
# Process cmd line.

getopt('a:in:x');

if ($opt_n) {
    $network_list_file = $opt_n;
    open my $netfile, '<', $network_list_file
        or die $!;
    @networks_raw = <$netfile>;
    close $netfile;
    print STDERR "- Reading networks from " . $network_list_file . "\n";
} else {
    print "Please specify a network list with -n\n";
    exit 1
}

if ($opt_a) {
    $address_list_file = $opt_a;
    open my $addrfile, '<', $address_list_file
        or die $!;
    @addresses_raw = <$addrfile>;
    close $addrfile;
    print STDERR "- Reading addresses from " . $address_list_file . "\n";
} else {
    print "Please specify an ip list file with -a\n";
    exit 2
}

#-----------------------------------------------------------------------
# Process input files.

#print @addresses_raw;
#print @networks_raw;

#print @addresses;
#print @networks;

print STDERR "- Processing networks ";

# Create network objects for each address.
push @addresses, new NetAddr::IP ($_) for @addresses_raw;

# Create network objects for each record.
for (@networks_raw) {
    # Crude check for range of IPs - convert to CIDR first.
    next unless /^[0-9]/;
    if ($_ =~ /\-/) {
        push @networks, Net::CIDR::range2cidr("$_");
        print '-';
    } else {
        push @networks, new NetAddr::IP ($_);
        print '.';
    }
}
print "\n";

print ("@networks\n");
#print @addresses;

print "\n";

#push @networks,  new NetAddr::IP ($_) for @networks_raw;

#-----------------------------------------------------------------------
# Compare.

for my $netblock (@networks) {
    chomp $netblock;


    for my $ip (@addresses) {
        chomp $ip;
        print '- Checking to see if "' . $ip . '" is in network "' . $netblock . '".' . "\n";

        print $ip, "\n"
            # FIXME - does not work with NetAddr::IP as included.
            if ($ip->within($netblock));
        }

}


#print join("\n", @{NetAddr::IP::coalesce($network_list_file,1,@addresses)}), "\n";

#-----------------------------------------------------------------------

