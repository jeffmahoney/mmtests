FINEGRAINED_SUPPORTED=yes
NAMEEXTRA=

run_bench() {
	$SCRIPTDIR/shellpacks/shellpack-bench-specjbb2013 \
		--instances            $SPECJBB_JVM_INSTANCES
	return $?
}
