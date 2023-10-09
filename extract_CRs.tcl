set lst [list]
set CRs [get_clock_regions]
foreach CR $CRs {
	set bottom_right [get_property BOTTOM_RIGHT_TILE [get_clock_regions $CR]]
	set top_left [get_property TOP_LEFT_TILE [get_clock_regions $CR]]
	lappend lst "$CR\t$bottom_right\t$top_left"
}
print_list $lst CRs {/home/bardia/Desktop/bardia/Timing_Characterization/Data/Load}
