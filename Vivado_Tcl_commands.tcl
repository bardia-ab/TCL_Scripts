get_pips -of [get_nodes INT_X6Y121/VCC_WIRE]
get_nodes -of [get_pips INT_X6Y121/INT.VCC_WIRE->>BOUNCE_E_0_FT1]
get_site_pins -of [get_nodes INT_X6Y121/BOUNCE_E_0_FT1]

set pips [get_pips -of [get_wires INT_X6Y121/VCC_WIRE]]
set length [llength $pips]
set site_pins {}
for {set i 0} {$i < $length} {incr i} {
	lappend site_pins [get_site_pins -of [lindex [get_nodes -of [lindex $pips $i]] 1]]
}

set wires [get_wires -of [get_tiles INT_X6Y121]]
set imux 0
set global 0
set node_sdq 0
set int_sdq 0
for {set i 0} {$i < [llength $wires]} {incr i} {
	if {[string match INT_X6Y121/INT_INT_SDQ_* [lindex $wires $i]]} {
		incr int_sdq
	} elseif {[string match INT_X6Y121/INT_NODE_GLOBAL_* [lindex $wires $i]]} {
		incr global
	} elseif {[string match INT_X6Y121/INT_NODE_IMUX* [lindex $wires $i]]} {
		incr imux
	} elseif {[string match INT_X6Y121/INT_NODE_SDQ_* [lindex $wires $i]]} {
		incr node_sdq
	}
}

set file [open {C:/Users/Sony/Desktop/ports.txt} w+]
for {set i 0} {$i < [llength $wires]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $wires $i]"
}
close $file

# command for printing a list in a txt file
proc print_list {list1 filename {root_path "C:/Users/Sony/Desktop/PIP Property"}} {
	set path "$root_path/$filename.txt"
	set file [open $path w+]
	foreach el $list1 {
		puts $file $el
	}
	close $file
}

# command for generating pip junctions without -filter it generates 1475 wires
set wires [get_wires -of [get_tiles INT_X6Y121] -filter {NUM_PIPS > 0}]

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

# commands for generating BUFFERED_2_1 PIPs
set buf_pips [get_pips -of_objects [get_tiles INT_X6Y121] -filter {IS_BUFFERED_2_1 == 1}]
set file [open {C:/Users/Sony/Desktop/buf_2_1_pips.txt} w+]
for {set i 0} {$i < [llength $buf_pips]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $buf_pips $i]"
}
close $file

# commands for generating UNBUFFERED PIPs
set unbuf_pips [get_pips -of_objects [get_tiles INT_X6Y121] -filter {IS_BUFFERED_2_1 == 0 && IS_BUFFERED_2_0 == 0}]
set file [open {C:/Users/Sony/Desktop/unbuf_pips.txt} w+]
for {set i 0} {$i < [llength $unbuf_pips]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $unbuf_pips $i]"
}
close $file

# commands for generating BUFFERED_2_0 PIPs		------------->	these pips are both BUFFERED_2_0 and BUFFERED_2_1
set buf_pips [get_pips -of_objects [get_tiles INT_X6Y121] -filter {IS_BUFFERED_2_0 == 1}]
set file [open {C:/Users/Sony/Desktop/buf_2_0_pips.txt} w+]
for {set i 0} {$i < [llength $buf_pips]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $buf_pips $i]"
}
close $file

# commands for generating DIRECTIONAL PIPs
set dirc_pips [get_pips -of_objects [get_tiles INT_X6Y121] -filter {IS_DIRECTIONAL == 1}]
set file [open {C:/Users/Sony/Desktop/directional_pips.txt} w+]
for {set i 0} {$i < [llength $dirc_pips]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $dirc_pips $i]"
}
close $file

# commands for generating UNDIRECTIONAL PIPs
set undirc_pips [get_pips -of_objects [get_tiles INT_X6Y121] -filter {IS_DIRECTIONAL == 0}]
set file [open {C:/Users/Sony/Desktop/undirectional_pips.txt} w+]
for {set i 0} {$i < [llength $undirc_pips]} {incr i} {
puts $file "[expr {$i + 1}] : [lindex $undirc_pips $i]"
}
close $file


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

get_pip {INT_X6Y121/BYPASS_E14} {INT_X6Y121/INT_NODE_IMUX_18_INT_OUT1}
get_pip [get_wires INT_X6Y121/BYPASS_E14] [get_wires INT_X6Y121/INT_NODE_IMUX_18_INT_OUT1]

# command for finding all available pips between two lists of wires
proc av_pips {list1 list2 {directional 1} {reverse 0}} {
	# set list1 [get_wires INT_X6Y121/LOGIC*]
	# set list2 [get_wires INT_X6Y121/INT_NODE_IMUX*]
	set pips [list]
	foreach	wire1 $list1 {
		foreach wire2 $list2 { 
			if { [get_pip $wire1 $wire2 $directional $reverse] ne "No PIP!"} {
				lappend pips [get_pip $wire1 $wire2 $directional $reverse] 
			}
		}
	}
	return $pips
}

# this command finds all pip junctions without any external nodes plus VCC_WIRE
get_nodes -of [get_tiles INT_X6Y121] -filter {NUM_WIRES == 1}

# this command finds all nodes connected to two CLB's pins in the West and East side (exception: AX, CX, F_I, H_I : NUM_WIREs = 3 also CIN, COUT are not connected to SM)
# NUM_WIRES equals number of tiles that a node spans. For two adjacent tiles like a SM and CLB is 2
get_nodes -of [get_tiles INT_X6Y121] -filter {NUM_WIRES == 2 && IS_PIN == 1}

# command for getting output/input wires of each pip from a list of pips
proc get_wire_pips {pips {out_port 1}} {
	set wires [list]
	foreach pip $pips {
		lappend wires [lindex [get_wires -of [get_pips $pip]] $out_port]
	}
	return [lsort -unique $wires]
}

# COMMAND FOR GETTING NODES OF SPECIFIC TYPE OF PIP JUNCTIONS	input: type=1	input/output: type=2	output: type=3
proc rcv_nodes {tile name type} {
	if {$type == 1} {
		set nodes [get_nodes -of [get_wires -of [get_tiles $tile] "$tile/$name" -filter {NUM_DOWNHILL_PIPS != 0 && NUM_UPHILL_PIPS == 0}]]
	} elseif {$type == 2} {
		set nodes [get_nodes -of [get_wires -of [get_tiles $tile] "$tile/$name" -filter {NUM_DOWNHILL_PIPS != 0 && NUM_UPHILL_PIPS != 0}]]
	} elseif {$type == 3} {
		set nodes [get_nodes -of [get_wires -of [get_tiles $tile] "$tile/$name" -filter {NUM_DOWNHILL_PIPS == 0 && NUM_UPHILL_PIPS != 0}]]
	}
	return $nodes
}

#command for generating different types of wires
set vlong [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_VLONG}] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]


#
set list1 [get_wires INT_X6Y121/LOGIC*]
set list2 [get_wires INT_X6Y121/INT_NODE_IMUX*]
set pip1 [av_pips $list1 $list2]
set wires_out1 [get_wire_pips $pip1]

set site_pins [lsort [get_site_pins -of [get_nodes -of [get_wires INT_X6Y121/IMUX*]]]]
lappend site_pins {*}[lsort [get_site_pins -of [get_nodes -of [get_wires INT_X6Y121/BYPASS*]]]]
lappend site_pins {*}[lsort [get_site_pins -of [get_nodes INT_X6Y121/BOUNCE*]]]
set wires_pins [get_wires -of [get_nodes -of [get_site_pins $site_pins]] -filter {TILE_NAME == INT_X6Y121}]
set pip2 [av_pips $wires_out1 $wires_pins]
set pip1_total [get_pips -of [get_wires $list2] -uphill]
set pip1_other [list]
foreach pip $pip1_total {
	if {$pip ni $pip1} {
		lappend	pip1_other $pip
	}
}
set wires_in2 [get_wire_pips $pip1_other 0]


set list1 [get_wires INT_X6Y121/INT_NODE_IMUX*]
set list2 [lsort [get_wires INT_X6Y121/BYPASS*]]
set list3 [get_wires INT_X6Y121/BOUNCE*]
set list4 [get_wires INT_X6Y121/IMUX*]
lappend list2 {*}[lsort $list3] {*}[lsort $list4]
