 set nets [get_nets -hierarchical -regexp .*CUTs_Inst/CUT.*Q_launch_int]
 set net_delays [list]
foreach net $nets {
	set max [get_property SLOW_MAX [get_net_delays -of [get_nets $net] -patterns *D]]
	set min [get_property FAST_MIN [get_net_delays -of [get_nets $net] -patterns *D]]
	lappend net_delays "$net\t$min\t$max"
}