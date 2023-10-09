# generating wires of different types of nodes
set vlong [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_VLONG}] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set hlong [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_HLONG}] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set vquad [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_VQUAD }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set hquad [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_HQUAD }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set double [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_DOUBLE  }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set single [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_SINGLE }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set local [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_LOCAL }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set pinbounce [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_PINBOUNCE }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set pinfeed [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_PINFEED }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set cle [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == NODE_CLE_OUTPUT }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]
set default [get_wires -of [get_nodes -of [get_tiles INT_X6Y121] -filter {INTENT_CODE_NAME == INTENT_DEFAULT }] -filter {TILE_NAME == INT_X6Y121 && NUM_PIPS != 0}]

#generating number of pips of wires
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $hlong -filter {NAME =~ *_BEG*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $vlong -filter {NAME =~ *_BEG*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $hquad -filter {NAME =~ *_BEG*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $vquad -filter {NAME =~ *_BEG*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $double -filter {NAME =~ *_BEG*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $single -filter {NAME =~ *_BEG*}]

get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $hlong -filter {NAME =~ *_END*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $vlong -filter {NAME =~ *_END*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $hquad -filter {NAME =~ *_END*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $vquad -filter {NAME =~ *_END*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $double -filter {NAME =~ *_END*}]
get_property NUM_PIPS [get_wires -of [get_tiles INT_X6Y121] $single -filter {NAME =~ *_END*}]

#program for listing wires, their DIR, start and end tiles
proc list_wires {tile} {
	set wires [get_wires -of [get_tiles $tile] -filter {NUM_PIPS > 0}]
	set nodes[get_nodes -of [get_wires $wires]]

}
