extends Node2D

# navrati spawnpoint pro tento svet
func getSpawn(index):
	if index == 0:
		return $spawn0.position
	elif index == 1:
		return $checkpoint1.position
	elif index == 2:
		return $checkpoint2.position
	elif index == 3:
		return $checkpoint3.position
	return null
