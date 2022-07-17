extends Node2D


export var dir = "save"


func show():
	var list = list_files_in_directory(dir)
	print(list) 
	$CanvasLayer/ItemList.clear()
	for item in list:
		var file = File.new()
		file.open(dir + "/" + item, File.READ)
		var data = file.get_var()
		file.close()
		$CanvasLayer/ItemList.add_item(item + " | Level: " + str(data.world_index), null, true)

	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files	


func _on_back_pressed():
	get_parent().showMain()


func _on_play_pressed():
	var sel = $CanvasLayer/ItemList.get_selected_items()
	if len(sel) > 0:
		var item = $CanvasLayer/ItemList.get_item_text(sel[0]) 
		item = item.split(" | ")[0]
		print(item)
		get_parent().loadGame(dir + "/" + item)
