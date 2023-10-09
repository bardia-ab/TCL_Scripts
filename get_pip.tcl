# commands for finding the pip between two wires
proc get_pip {wire1 wire2 {directional 1} {reverse 0}} {
	set tile [lindex [split $wire1 "/"] 0]
	if {$directional == 0} {
		set pips1 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire1"]]
		set pips2 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire2"]]
	} else {
		if {$reverse == 0} {
			set pips1 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire1"] -downhill]
			set pips2 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire2"] -uphill]
		} else {
			set pips1 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire1"] -uphill]
			set pips2 [get_pips -of [get_wires -of [get_tiles $tile] -filter "NAME =~ $wire2"] -downhill]
		}
	}
	set com_pips [list]
	foreach el $pips1 {
		if {$el in $pips2} {
			lappend com_pips $el
		}
	}
	if {$com_pips == [list]} {
		set com_pips "No PIP!"
	}
	return $com_pips
}