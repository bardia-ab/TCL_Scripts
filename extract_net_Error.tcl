set nets [get_nets -hierarchical -regexp .*CUT/o_Error]
foreach net $nets {
	set pips [get_pips -of [get_nets $net]]
	set numbers [regexp -all -inline {[[0-9]+]} $net]
	set file "Error_[string map [list {[} "" {]} ""] [lindex $numbers 0]]_[string map [list {[} "" {]} ""] [lindex $numbers 1]]"
	print_list $pips $file {C:/Users/t26607bb/Desktop/CPS_Project/New Path Search/Data/Load/nets}

}