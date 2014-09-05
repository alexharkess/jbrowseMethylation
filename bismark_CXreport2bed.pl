#!/usr/bin/perl
use strict;
use warnings;

my @reports = <*CX_report.txt>;
for my $report (@reports) {
    open IN, '<', $report;
    while (<IN>) {
	my ($scaffold, $position, $strand, $count_meth, $count_unmeth, $context, $trinuc) = split /\s+/, $_;
	
