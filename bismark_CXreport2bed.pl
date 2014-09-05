#!/usr/bin/perl
use strict;
use warnings;

my @reports = <*CX_report.txt>;
for my $report (@reports) {

    open IN, '<', $report;
    
    open CpGplus,  '>', "$report\.CpGplus.bed";
    open CpGminus, '>', "$report\.CpGminus.bed";
    open CHGplus,  '>', "$report\.CHGplus.bed";
    open CHGminus, '>', "$report\.CHGminus.bed";
    open CHHplus,  '>', "$report\.CHHplus.bed";
    open CHHminus, '>', "$report\.CHHminus.bed";

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
            print CHHminus "$scaffold\t$position_start\t$position_stop\t$percent_meth\n";
	}
    }
}

# now convert the bedGraph files to bigwig using ucsc bedgraph2bigwig
# forking the process to spawn one thread / bedGraph file

my @beds = <*.bed>;
for my $bed (@beds) {
    my $pid = fork();
    if ($pid==0) { # child
        system "/usr/local/ucsc/latest/bedGraphToBigWig $bed chromLens $bed\.bigwig";
        die "Exec $i failed: $!\n";
    } elsif (!defined $pid) {
        warn "Fork $i failed: $!\n";
    }
}

1 while wait() >= 0;

