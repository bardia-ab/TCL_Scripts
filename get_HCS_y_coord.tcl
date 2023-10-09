set CRs [get_clock_regions -filter {NUM_SITES > 1}]
set lst [list]
foreach CR $CRs {
	set tiles [get_tiles -of [get_clock_regions $CR] RCLK*]
	regexp {X(\d+)Y(\d+)} [lindex $tiles 0] coord x y

	lappend lst "$CR\t$y"
}
print_list $lst HCS {/home/bardia/Desktop/bardia/Timing_Characterization/Data/Load}
