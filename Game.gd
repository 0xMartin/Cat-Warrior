extends Node2D

var player_scene = preload("res://entity/player/Player.tscn")

func _physics_process(delta):
	if $Player == null:
		print("game over")

# nacte jiny svet podle indexu (0, 1, ... n)
func loadWorld(index):
	pass
	
# nastavi hraci novou pozici ve svete. index (0, 1, ... n) odpovida urcitemu spawnpointu v urcitem svete
# pokud hrac zeprel spawne ho znovu
func setPlayerPosition(spawnpoint_index):
	var position = $World1.getSpawn(spawnpoint_index)
	if $Player == null:
		add_child(player_scene.instance())
	if position != null:
		$Player.position = position
