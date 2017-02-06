#!/usr/bin/perl -slw

# Source, 2013-05-07
# http://www.perlmonks.org/?node_id=926659
# http://www.perlmonks.org/?displaytype=selectcode;node_id=926799

use strict;
use Time::HiRes qw[ time ];
use Data::Dump qw[ pp ];

use enum qw[ CIDR NETWORK SIZE RANGE ];
use enum qw[ FIRST LAST ];

sub dd2n { unpack 'N', pack 'C4', split '\.', $_[0] }
sub n2dd { join '.', unpack 'C4', pack 'N', $_[0]   }

sub CIDR2Range {
    my( $network, $bits ) = $_[ 0 ] =~ m[([^/]+)/(\d+)]
        or die "Bad CIDR: '$_[0]'";
    my $start =  dd2n( $network );
    my $hostMask = ( 1 << ( 32 - $bits ) ) -1;
    die "Bad CIDR: '$_[0]'" if $start & $hostMask;
    my $end = $start | $hostMask;
    return [ $start, $end ];
}

sub rangesOverlap {
    my( $thisFirst, $thisLast ) = @{ $_[0] };
    my( $thatFirst, $thatLast ) = @{ $_[1] };
    return 1 unless
        $thisFirst > $thatLast or $thatFirst > $thisLast;
}

sub isContainedBy {
    my( $thisFirst, $thisLast ) = @{ $_[0] };
    my( $thatFirst, $thatLast ) = @{ $_[1] };
    return 1
        if  $thisFirst <= $thatFirst
        and $thisLast  >= $thatLast;
}

my $start = time;

chomp( my @CIDRs = <> );

my $count = @CIDRs;

@CIDRs = sort {
    $b->[SIZE] <=> $a->[SIZE] || $b->[RANGE][FIRST] <=> $a->[RANGE][FIRST]
} map[
    $_, m[([^/]+)/(\d+)$], CIDR2Range( $_ )
], @CIDRs;

#pp \@CIDRs;

my @forest;

OUTER: while( @CIDRs ) {
    my $next = pop @CIDRs;
    my $that = $next->[RANGE];
    for my $tree ( @forest ) {
        my $this = $tree->{root}[RANGE];
        if( isContainedBy( $this, $that ) ) {
            push @{ $tree->{contains} }, $next;
            next OUTER;
        }
    }
    push @forest, { root => $next };
}

@forest = sort{
    $a->{root}[RANGE][FIRST] <=> $b->{root}[RANGE][FIRST]
} @forest;

for my $tree ( @forest ) {
    print $tree->{root}[CIDR];
    print "\t", join ' ', map $_->[CIDR], @{ $tree->{contains} };
}

printf STDERR "Took %.3f seconds for $count CIDRs\n",
    time() - $start;

