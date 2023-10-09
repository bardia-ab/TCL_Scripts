proc get_timing_model {clock_region} {
	set tiles [get_tiles -of [get_clock_regions $clock_region] -filter "NAME =~ INT_X*"]
	foreach tile $tiles {
		print_list [gen_pips $tile] "PIPs.$tile" "C:/Users/t26607bb/Desktop/graph_zcu9eg/pips"
		print_list [gen_wires $tile] "WIREs.$tile" "C:/Users/t26607bb/Desktop/graph_zcu9eg/wires"
	}
}

proc gen_wires {tile} {
	set wires [list]
	set nodes [get_nodes -of [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0 || IS_OUTPUT_PIN == 1 || IS_INPUT_PIN == 1}] -filter {NUM_WIRES > 1}]
	foreach node $nodes {
		set delays [get_property DELAY [get_speed_models -of [get_nodes -of [get_tiles $tile] $node]]]
		set start_tile [lindex [split $node '/'] 0]
		set start_port [get_wires -of [get_nodes -of [get_tiles $start_tile] $node] -filter {NUM_PIPS > 0 && NUM_UPHILL_PIPS > 0 || IS_OUTPUT_PIN == 1}]
		set end_ports [get_wires -of [get_nodes -of [get_tiles $start_tile] $node] -filter {(NUM_PIPS > 0 && NUM_UPHILL_PIPS == 0) || IS_INPUT_PIN == 1}]
		if {[string match $start_tile $tile] == 1} {
			foreach end_port $end_ports {
				lappend wires "$start_port\t$end_port"
			}
		} else {
			foreach end_port $end_ports {
				if {[string match [lindex [split $end_port '/'] 0] $tile] == 1} {
					set wire "$start_port\t$end_port"
					foreach delay $delays {
						set wire "$wire\t$delay"
					}
					lappend wires $wire
				}
			}
		}
	}
	return $wires
}

proc gen_pips {tile} {
	set pips_list [list]
	set pips [get_pips -of [get_tiles $tile]]
	foreach pip $pips {
		if {[string match *VCC_WIRE* $pip]} {
			continue
		}
		set delay [get_property DELAY [get_speed_models -of [get_pips $pip]]]
		if {[string match *<<->>* $pip]} {
			set pip_port [wsplit $pip <<->>]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]\t$delay"
			lappend pips_list "$tile/[lindex $pip_port 1]\t$tile/[lindex $pip_port 0]\t$delay"
		} elseif {[string match *->>* $pip] } {
			set pip_port [wsplit $pip ->>]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]\t$delay"		} else {
			set pip_port [wsplit $pip ->]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]\t$delay"
		}
	}
	return $pips_list
}

proc print_list {list1 filename {root_path "C:/Users/Sony/Desktop/PIP Property"}} {
	set path "$root_path/$filename.txt"
	set file [open $path w+]
	foreach el $list1 {
		puts $file $el
	}
	close $file
}

proc wsplit {string sep} {
    set first [string first $sep $string]
    if {$first == -1} {
        return [list $string]
    } else {
        set l [string length $sep]
        set left [string range $string 0 [expr {$first-1}]]
        set right [string range $string [expr {$first+$l}] end]
        return [concat [list $left] [wsplit $right $sep]]
    }
}