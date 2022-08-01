extends Node

func get_file(folder):
	var gathered_files = []
	var dir = Directory.new()
	
	dir.open(folder)
	dir.list_dir_begin()
	
	var file = dir.get_next()
	while file:
		if not file.begins_with(".") and not file.ends_with(".import"):
			gathered_files.append(folder + file)
		file = dir.get_next()
		
	return gathered_files
