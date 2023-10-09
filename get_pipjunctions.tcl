#command for generating pip junctions
# 1: only input 2:	only output 3:	input/output 0:	all
proc get_pipjunctions {tile {type 0}} {	
	if {$type == 1} {
		set wires [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0 && NUM_UPHILL_PIPS == 0}]
	} elseif {$type == 2} {
		set wires [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0 && NUM_DOWNHILL_PIPS == 0}]
	} elseif {$type == 3} {
		set wires [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0 && NUM_UPHILL_PIPS != 0 && NUM_DOWNHILL_PIPS != 0}]
	} else {
		set wires [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0}]
	}
	return $wires
}