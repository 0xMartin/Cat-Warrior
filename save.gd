extends Node

class_name Save

export var player_name = ""
export var world_index = 0
export var spawnpoint_index = 0


func toJSON():
	var data = {
		"player_name": player_name,
		"world_index": world_index,
		"spawnpoint_index": spawnpoint_index
	}
	return data
	
	
func loadFromJSON(json):
	player_name = json.player_name
	world_index = json.world_index
	spawnpoint_index = json.spawnpoint_index
