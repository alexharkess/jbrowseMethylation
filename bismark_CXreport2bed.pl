#!/usr/bin/perl
use strict;
use warnings;

my @reports = <*CX_report.txt>;
for my $report (@reports) {

    open IN, '<', $report;
    
    open CpGplus,  '>', "$report\.CpGplus";
    open CpGminus, '>', "$report\.CpGminus";
    open CHGplus,  '>', "$report\.CHGplus";
    open CHGminus, '>', "$report\.CHGminus";
    open CHHplus,  '>', "$report\.CHHplus";
    open CHHminus, '>', "$report\.CHHminus";

    while (<IN>) {
	my ($scaffold, $position_start, $strand, $count_meth, $count_unmeth, $context, $trinuc) = split /\s+/, $_;
	my $position_stop = $position_start + 1;
	my $percent_meth = $count_meth / ($count_meth + $count_unmeth);
	
	if ($strand eq "+" && $context eq "CG") {
	    print CpGplus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
	if ($strand eq "-" && $context eq "CG") {
	    print CpGminus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
	if ($strand eq "+" && $context eq "CHG") {
            print CHGplus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
	if ($strand eq "-" && $context eq "CHG") {
            print CpGminus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
	if ($strand eq "+" && $context eq "CHH") {
            print CHHplus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
	if ($strand eq "-" && $context eq "CHH") {
            print CHHplus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
    }

# now convert the bedGraph files to bigwig using ucsc bedgraph2bigwig


