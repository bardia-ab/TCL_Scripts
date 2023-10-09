#command for getting graph of a specific clock region
proc get_graph {clock_region} {
	set tiles [get_tiles -of [get_clock_regions $clock_region] -filter "NAME =~ INT_X*"]
	foreach tile $tiles {
		print_list [gen_pips $tile] "PIPs.$tile" "C:/Users/t26607bb/Desktop/graph/pips"
		print_list [gen_wires $tile] "WIREs.$tile" "C:/Users/t26607bb/Desktop/graph/wires"
		gen_clb $tile
	}
}

proc gen_wires {tile} {
	set wires [list]
	set nodes [get_nodes -of [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0 || IS_OUTPUT_PIN == 1 || IS_INPUT_PIN == 1}] -filter {NUM_WIRES > 1}]
	foreach node $nodes {
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
					lappend wires "$start_port\t$end_port"
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
		if {[string match *<<->>* $pip]} {
			set pip_port [wsplit $pip <<->>]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]"
			lappend pips_list "$tile/[lindex $pip_port 1]\t$tile/[lindex $pip_port 0]"
		} elseif {[string match *->>* $pip] } {
			set pip_port [wsplit $pip ->>]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]"		} else {
			set pip_port [wsplit $pip ->]
			lset pip_port 0 [lindex [split [lindex $pip_port 0] .] 1]
			lappend pips_list "$tile/[lindex $pip_port 0]\t$tile/[lindex $pip_port 1]"
		}
	}
	return $pips_list
}

proc gen_clb {tile} {
	set nodes_osp [get_nodes -of [get_tiles $tile] -filter {INTENT_CODE_NAME == NODE_CLE_OUTPUT && NAME !~ *Q*}]
	set nodes_osp_reg [get_nodes -of [get_tiles $tile] -filter {INTENT_CODE_NAME == NODE_CLE_OUTPUT && NAME =~ *Q*}]
	set nodes_imux [get_nodes -of [get_tiles $tile] -filter "INTENT_CODE_NAME == NODE_PINFEED && NAME =~$tile/IMUX*"]
	set nodes_direct [get_nodes -of [get_tiles $tile] -filter "INTENT_CODE_NAME == NODE_PINBOUNCE && NAME =~$tile*"]
	set nodes_isp [list {*}$nodes_imux {*}$nodes_direct]
	set lst1 [list]
	set lst2 [list]
	set tile1 None
	set tile2 None
	set wires_osp1 [list]
	set wires_osp_reg1 [list]
	set wires_isp_imux1 [list]
	set wires_isp_direct1 [list]
	set wires_osp2 [list]
	set wires_osp_reg2 [list]
	set wires_isp_imux2 [list]
	set wires_isp_direct2 [list]
	foreach node $nodes_osp {
		if {[string match $tile1 None] == 1} {
			set tile1 [lindex [split $node /] 0]
			lappend wires_osp1 [lindex [get_wires -of [get_nodes -of [get_tiles $tile1] $node]] 0]
		} elseif {[string match [lindex [split $node /] 0] $tile1] == 0 && [string match $tile2 None] == 1} {
			set tile2 [lindex [split $node /] 0]
			lappend wires_osp2 [lindex [get_wires -of [get_nodes -of [get_tiles $tile2] $node]] 0]
		} elseif {[string match [lindex [split $node /] 0] $tile1] == 1} {
			lappend wires_osp1 [lindex [get_wires -of [get_nodes -of [get_tiles $tile1] $node]] 0]
		} else {
			lappend wires_osp2 [lindex [get_wires -of [get_nodes -of [get_tiles $tile2] $node]] 0]
		}
	}
	foreach node $nodes_osp_reg {
		if {[string match [lindex [split $node /] 0] $tile1] == 1} {
			lappend wires_osp_reg1 [lindex [get_wires -of [get_nodes -of [get_tiles $tile1] $node]] 0]
		} else {
			lappend wires_osp_reg2 [lindex [get_wires -of [get_nodes -of [get_tiles $tile2] $node]] 0]
		}
	}
	set tiles [list $tile1 $tile2]
	foreach node $nodes_isp {
		set wires [get_wires -of [get_nodes -of [get_tiles $tile] $node]]
		foreach wire $wires {
			set wire_tile [lindex [split $wire /] 0]
			if {[string match $wire_tile $tile1] == 1} {
				if {[lsearch $nodes_imux $node] != -1} {
					lappend wires_isp_imux1 $wire
				} elseif {[lsearch $nodes_direct $node] != -1} {
					lappend wires_isp_direct1 $wire
				}
			} elseif {[string match $wire_tile $tile2] == 1} {
				if {[lsearch $nodes_imux $node] != -1} {
					lappend wires_isp_imux2 $wire
				} elseif {[lsearch $nodes_direct $node] != -1} {
					lappend wires_isp_direct2 $wire
				}

			}
		}
	}
	foreach wire $wires_isp_imux1 {
		set ble [string range [lindex [wsplit $wire SITE_0_] 1] 0 0]
		foreach osp [list {*}$wires_osp1 {*}$wires_osp_reg1] {
			set ble2 [string range [lindex [wsplit $osp SITE_0_] 1] 0 0]
			if {[string match $ble $ble2] == 1} {
				lappend lst1 "$wire\t$osp"
			}
		}
	}
	foreach wire $wires_isp_imux2 {
		set ble [string range [lindex [wsplit $wire SITE_0_] 1] 0 0]
		foreach osp [list {*}$wires_osp2 {*}$wires_osp_reg2] {
			set ble2 [string range [lindex [wsplit $osp SITE_0_] 1] 0 0]
			if {[string match $ble $ble2] == 1} {
				lappend lst2 "$wire\t$osp"
			}
		}
	}
	foreach wire $wires_isp_direct1 {
		set ble [string range [lindex [wsplit $wire SITE_0_] 1] 0 0]
		foreach osp $wires_osp_reg1 {
			set ble2 [string range [lindex [wsplit $osp SITE_0_] 1] 0 0]
			if {[string match $ble $ble2] == 1} {
				lappend lst1 "$wire\t$osp"
			}
		}
	}
	foreach wire $wires_isp_direct2 {
		set ble [string range [lindex [wsplit $wire SITE_0_] 1] 0 0]
		foreach osp $wires_osp_reg2 {
			set ble2 [string range [lindex [wsplit $osp SITE_0_] 1] 0 0]
			if {[string match $ble $ble2] == 1} {
				lappend lst2 "$wire\t$osp"
			}
		}
	}
	print_list [lsort $lst1] $tile1 "C:/Users/t26607bb/Desktop/graph/clb"
	if {[string match None $tile2] == 0} {
		print_list [lsort $lst2] $tile2 "C:/Users/t26607bb/Desktop/graph/clb"
	}
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