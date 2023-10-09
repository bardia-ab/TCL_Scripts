set placed_cells [get_cells -hierarchical -filter "STATUS==PLACED"]
set cell_consts [list]
foreach cell $placed_cells {
	set loc [get_property LOC [get_cells $cell]]
	set bel [get_property BEL [get_cells $cell]]
	lappend cell_consts "set_property LOC $loc \[get_cells $cell\]"
	lappend cell_consts "set_property BEL $bel \[get_cells $cell\]"
}
print_list $cell_consts cell_const "C:/Users/t26607bb/Desktop"

set routed_nets [get_nets -hierarchical -filter "ROUTE_STATUS==ROUTED && TYPE==SIGNAL"]
set net_consts [list]
foreach net $routed_nets {
	set route [get_property ROUTE [get_nets $net]]
	lappend net_consts "set_property FIXED_ROUTE $route \[get_nets $net\]"

}
print_list $net_consts net_const "C:/Users/t26607bb/Desktop"

set routed_nets [get_nets -hierarchical -filter "ROUTE_STATUS==ROUTED"]
set used_pips [list]
foreach net $routed_nets {
	foreach pip [get_pips -of [get_nets $net]] {
		lappend used_pips $pip 
	}
	set used_pips [lsort -unique $used_pips]
}
print_list $used_pips used_pips "C:/Users/t26607bb/Desktop"