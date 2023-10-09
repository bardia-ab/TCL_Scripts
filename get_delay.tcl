# This command returns the "total", "net", or "logic" delay of a path
proc get_delay {net {mode {total}}} {

	if {$mode == {net}} {
		set delay [get_property DATAPATH_NET_DELAY [get_timing_paths -through [get_nets $net]]]
	} elseif {$mode == {logic}} { 
		set delay [get_property DATAPATH_LOGIC_DELAY [get_timing_paths -through [get_nets $net]]]
	} else {
		set delay [get_property DATAPATH_DELAY [get_timing_paths -through [get_nets $net]]]
	}
	return $delay
}