proc select_path {start_tile node color_index} {
	#set dest [get_tiles -of [get_wires -of [get_nodes "$start_tile/$node"] -filter {NUM_PIPS != 0}] -filter " NAME != $start_tile"]
	highlight_objects -color_index $color_index [get_nodes "$start_tile/$node"]
	set next_dest [get_wires -of [get_nodes "$start_tile/$node"] -filter "NAME =~ *END?"]
	regsub "END" $next_dest "BEG" next_src
	set next_tile [get_tiles -of [get_wires $next_dest]]
	highlight_objects -color_index $color_index [get_pips -of [get_tiles $next_tile] "$next_tile/INT.[lindex [split $next_dest "/"] 1]->>[lindex [split $next_src "/"] 1]"]
	while {[string compare [get_tiles -of [get_wires $next_src]] $start_tile]} {
		highlight_objects -color_index $color_index [get_nodes $next_src]
		set next_dest [get_wires -of [get_nodes $next_src] -filter "NAME =~ *END?"]
		regsub "END" $next_dest "BEG" next_src
		set next_tile [get_tiles -of [get_wires $next_dest]]
		if {$next_tile == $start_tile} {
			continue
		} else {
		highlight_objects -color_index $color_index [get_pips -of [get_tiles $next_tile] "$next_tile/INT.[lindex [split $next_dest "/"] 1]->>[lindex [split $next_src "/"] 1]"]
		}
	}

}

#this command lists a pair of node and destination tile
proc dest_nodes {tile} {
	set lst [list]
	set nodes [get_nodes -of [get_tiles $tile] -filter "NAME =~ $tile/WW* || NAME =~ $tile/SS* || NAME =~ $tile/NN* || NAME =~ $tile/EE*"]
	foreach node $nodes {
		set tiles [get_tiles -of [get_wires -of [get_nodes -of [get_tiles $tile] $node] -filter "NUM_PIPS > 0 && TILE_NAME != $tile"]]
		foreach dest_tile $tiles {
			lappend	lst "$node\t$dest_tile"
		}
	}
	return $lst
}

#this command lists a pair of wire and destination tile
proc dest_wires {tile} {
	set lst [list]
	set nodes [get_nodes -of [get_tiles $tile] -filter "NAME =~ $tile/WW* || NAME =~ $tile/SS* || NAME =~ $tile/NN* || NAME =~ $tile/EE* || NAME =~ $tile/INODE* || NAME =~ $tile/SDQNODE* || NAME =~ $tile/BOUNCE*"]
	foreach node $nodes {
		set src_wire [get_wires -of [get_nodes -of [get_tiles $tile] $node] -filter "NUM_PIPS > 0 && TILE_NAME == $tile"]
		set dest_wires [get_wires -of [get_nodes -of [get_tiles $tile] $node] -filter "NUM_PIPS > 0 && TILE_NAME != $tile"]
		set tiles [get_tiles -of [get_wires -of [get_nodes -of [get_tiles $tile] $node] -filter "NUM_PIPS > 0 && TILE_NAME != $tile"]]
		foreach dest_tile $tiles dest_wire $dest_wires {
			print_list [get_input_pins $dest_tile] "Tile_Info/$dest_tile\_dest"
			lappend	lst "$src_wire\t$dest_wire"
		}
	}
	print_list $lst Tile_Info/Destination
	print_list [get_input_pins $tile] "Tile_Info/$tile\_dest"
	return $lst
}

#this command lists a pair of wire and source tile
proc src_wires {tile} {
	set lst [list]
	set wires [get_wires -of [get_tiles $tile] -filter "NUM_DOWNHILL_PIPS > 0 && NUM_UPHILL_PIPS == 0  && (NAME =~ */WW* || NAME =~ */SS* || NAME =~ */NN* || NAME =~ */EE* || NAME =~ $tile/INODE* || NAME =~ $tile/SDQNODE* || NAME =~ $tile/BOUNCE*)"]
	foreach wire $wires {
		#set tile [get_tiles -of [get_wires -of [get_nodes -of [get_wires -of [get_tiles $tile] $wire]] -filter {NUM_UPHILL_PIPS > 0}]]
		set tile1 [lindex [split [get_nodes -of [get_wires -of [get_tiles $tile] $wire]] "/"] 0]
		print_list [get_output_pins $tile1] "Tile_Info/$tile1\_src"
		set src_wire [get_nodes -of [get_wires -of [get_tiles $tile] $wire]]
		lappend lst "$src_wire\t$wire"
	}
	print_list $lst Tile_Info/Source
	print_list [get_output_pins $tile] "Tile_Info/$tile\_src"
	return $lst
}

#This command generates wires connected to input site pins of neighboring CLBs	pinbounce : bypass, bounce
proc get_input_pins {tile {pinbounce 1}} {
	set lst [list]
	if {$pinbounce == 0} {
		set wires [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && NAME !~ $tile/CTRL*"]
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && NAME !~ $tile/CTRL*"] -filter "NAME =~ SLICE*"]
	} else {
		set wires [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && INTENT_CODE_NAME == NODE_PINBOUNCE"]
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && INTENT_CODE_NAME == NODE_PINBOUNCE"] -filter "NAME =~ SLICE*"]
	}
	foreach wire $wires pin $pins {
		set pins_tile [get_tiles -of [get_site_pins $pin]]
				if {[string match CLEM* $pins_tile]} {
			set pref CLE_CLE_M_SITE_0_
		} else {
			set pref CLE_CLE_L_SITE_0_
		}
		lappend lst "[string map {/ .} $wire]\t$pins_tile.$pref[lindex [split $pin "/"] 1]"
	}
	return $lst	
}

#This command generates wires connected to output site pins on neighboring CLBs
proc get_output_pins {tile {all 0}} {
	set lst [list]
	if {$all == 1} {
		set wires [get_wires -of [get_nodes -of [get_tiles $tile] -filter {IS_OUTPUT_PIN == 1}] -filter "NAME =~ $tile/LOGIC_OUTS*"]
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter {IS_OUTPUT_PIN == 1}] -filter "NAME =~ SLICE*"]
	} else {
		set wires [get_wires -of [get_nodes -of [get_tiles $tile] -filter {IS_OUTPUT_PIN == 1 && (NAME =~ *O || NAME =~ *MUX)}] -filter "NAME =~ $tile/LOGIC_OUTS*"]
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter {IS_OUTPUT_PIN == 1 && (NAME =~ *O || NAME =~ *MUX)}] -filter "NAME =~ SLICE*"]
	}
	foreach wire $wires pin $pins {
		set pins_tile [get_tiles -of [get_site_pins $pin]]
		if {[string match CLEM* $pins_tile]} {
			set pref CLE_CLE_M_SITE_0_
		} else {
			set pref CLE_CLE_L_SITE_0_
		}
		lappend lst "[string map {/ .} $wire]\t$pins_tile.$pref[lindex [split $pin "/"] 1]"
	}
	return $lst	
}


#This command generates input site pins of neighboring CLBs	pinbounce : bypass, bounce
proc get_input_pins {tile {pinbounce 1}} {
	if {$pinbounce == 0} {
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && NAME !~ $tile/CTRL*"] -filter {NAME =~ SLICE*}]
	} else {
		set pins [get_site_pins -of [get_nodes -of [get_tiles $tile] -filter "IS_INPUT_PIN == 1 && NAME =~ $tile/* && INTENT_CODE_NAME == NODE_PINBOUNCE"] -filter {NAME =~ SLICE*}]
	}
	return $pins
}


set lst [list]
for {set i 0} {$i < 33} {incr i} {
	lappend lst [llength [get_input_pins "INT_X[expr $i]Y121"]]
}