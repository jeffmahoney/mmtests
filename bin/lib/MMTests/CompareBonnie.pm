# CompareBonnie.pm
package MMTests::CompareBonnie;
use MMTests::Compare;
our @ISA = qw(MMTests::Compare);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "CompareBonnie",
		_DataType    => MMTests::Compare::DATA_OPSSEC,
		_FieldLength => 16,
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

1;
