#!/usr/bin/env perl

# Ref: http://www.sysarch.com/Perl/sort_paper.html
# NOTE: slower than ipsort shell-bashed 'sort' method,
# but made available for systems without 'sort'.

my @in = <STDIN>;

my @out =
  map  substr($_, 4) =>
  sort
  map  pack('C4' =>
    /(\d+)\.(\d+)\.(\d+)\.(\d+)/)
      . $_ => @in;

print @in;

