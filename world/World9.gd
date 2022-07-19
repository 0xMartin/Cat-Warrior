extends Node2D


# navrati spawnpoint pro tento svet
func getSpawn(index):
	match index:
		0:
			return $spawn0.position
	return null


func getName():
	return "Brana"
