extends Node2D


# navrati spawnpoint pro tento svet
func getSpawn(index):
	match index:
		0:
			return $spawn0.position
		1:
			return $checkpoint1.position
		2:
			return $checkpoint2.position
	return null


func getName():
	return "Vlci stezka"
