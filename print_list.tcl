# command for printing a list in a txt file
proc print_list {list1 filename {root_path "C:/Users/Sony/Desktop/PIP Property"}} {
	set path "$root_path/$filename.txt"
	set file [open $path w+]
	foreach el $list1 {
		puts $file $el
	}
	close $file
}