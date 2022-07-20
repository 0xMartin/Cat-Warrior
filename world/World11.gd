extends Node2D


# navrati spawnpoint pro tento svet
func getSpawn(index):
	# zapne svetlo hraci
	if GameConfig.current_player != null:
		GameConfig.current_player.light(true)
	# navrati spawnpoint
	match index:
		0:
			return $spawn0.position
	return null


func getName():
	return "Cesta ohnem"
