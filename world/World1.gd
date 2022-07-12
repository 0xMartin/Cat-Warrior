extends Node2D


func getSpawn(index):
	if index == 0:
		return $spawn0.position
	return null
