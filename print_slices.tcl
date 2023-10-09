proc print_slices {} {
	file delete -force "D:/delay_faults/Vivado_netlist"
	file mkdir "D:/delay_faults/Vivado_netlist"
	set nets [get_nets -hierarchical -filter "NAME =~ *CLE* && FLAT_PIN_COUNT==3"]
	set str [lindex [split [lindex [split [lindex $nets 0] /] 1] _] 1]
	set num [string range $str [expr [string last g $str] + 1] end]
	set cells [get_cells -hierarchical -filter {NAME =~ *CLE*}]
	set lst [list]
	foreach cell $cells {
		set label [lindex [split $cell /] end]
		set index [string last _ $label]
		set tile [string range $label 0 [expr $index - 1]]
		set bel [string range $label [expr $index + 1] end]
		set slice [get_sites -of [get_tiles $tile]]
		set type [get_property SITE_TYPE [get_sites $slice]]
		lappend lst "$cell\t$slice\t$type\t$bel" 
	}
	print_list $lst "slice_info$num" "D:/delay_faults/Vivado_netlist"
	print_list $nets "net_info$num" "D:/delay_faults/Vivado_netlist"
}
