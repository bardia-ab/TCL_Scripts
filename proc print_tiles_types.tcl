proc print_tiles_types {store_path} {
    #prints types of tiles around a SM in a row
	set tiles [get_tiles "INT_X*"]
	set lst [list]
	foreach tile $tiles {
		set TILE_X [get_property TILE_X [get_tiles $tile]]
		set TILE_Y [get_property TILE_Y [get_tiles $tile]]
		set TYPE_W [get_property TYPE [get_tiles -filter "TILE_Y==$TILE_Y && TILE_X == [expr $TILE_X - 1]"]]
		set TYPE_E [get_property TYPE [get_tiles -filter "TILE_Y==$TILE_Y && TILE_X == [expr $TILE_X + 1]"]]
		lappend lst "$TYPE_W\t$tile\t$TYPE_E"
	}

	print_list $lst "TILE_TYPE" $store_path
}