# ExtractSembench.pm
package MMTests::ExtractSembenchcommon;
use MMTests::SummariseMultiops;
use VMR::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;
use Data::Dumper qw(Dumper);

sub initialise() {
	my ($self, $reportDir, $testName) = @_;

	$self->SUPER::initialise();

	my $fieldLength = $self->{_FieldLength} = 12;
	$self->{_FieldLength} = $fieldLength;
	$self->{_SummaryLength} = $fieldLength;
	$self->{_TestName} = $testName;
	$self->{_FieldFormat} = [ "%-${fieldLength}d", "%$fieldLength.2f" , "%${fieldLength}.3f%%" ];
}

sub uniq {
	my %seen;
	grep !$seen{$_}++, @_;
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($tp, $name);
	my $file_wk = "$reportDir/noprofile/workloads";
	open(INPUT, "$file_wk") || die("Failed to open $file_wk\n");
	my @workloads = split(/ /, <INPUT>);
	$self->{_Workloads} = \@workloads;
	close(INPUT);

	my @threads;
	foreach my $wl (@workloads) {
		chomp($wl);
		my @files = <$reportDir/noprofile/$wl-*.log>;
		foreach my $file (@files) {
			my @elements = split (/-/, $file);
			my $thr = $elements[-1];
			$thr =~ s/.log//;
			push @threads, $thr;
		}
	}
	@threads = sort {$a <=> $b} @threads;
	@threads = uniq(@threads);

	foreach my $nthr (@threads) {
		foreach my $wl (@workloads) {
			my $file = "$reportDir/noprofile/$wl-$nthr.log";
			my $nr_samples = 0;

			open(INPUT, $file) || die("Failed to open $file\n");
			while (<INPUT>) {
				my $line = $_;
				my @tmp = split(/\s+/, $line);

				if ($line =~ /run time.* seconds ([0-9]+) worker burns per second/) {
					$tp = $1;
				} else {
					next;
				}
				push @{$self->{_ResultData}}, [ "sembench-$wl-$nthr", ++$nr_samples, $tp ];
			}

			close INPUT;
		}
	}

	my @ops;
	foreach my $wl (@workloads) {
		foreach my $nthr (@threads) {
			push @ops, "sembench-$wl-$nthr"
		}
	}
	$self->{_Operations} = \@ops;
}
