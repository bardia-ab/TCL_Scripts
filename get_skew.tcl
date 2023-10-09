# skew = Destination Clock Delay (DCD) - Source Clock Delay (SCD) + Clock Pessimism Removal (CPR)
# Clock Pessimism Removal (CPR) is the removal of artificially induced pessimism from the common clock path between launching startpoint and capturing endpoint.
proc get_skew {net} {

	set skew [get_property SKEW [get_timing_paths -through [get_nets $net]]]
	return $skew
}