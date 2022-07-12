extends Node2D

var activated = false

export var index = 0


# automaticky aktivuje spawnpoint (v save hrace nastavi jeho index)
func activate():
	$AnimatedSprite.play("on")
	activated = true
	GameConfig.player_save.spawnpoint_index = max(GameConfig.player_save.spawnpoint_index, index)
	

# pokud je hrac dostatecne blizko a zasahne spawnpoint pak se aktivuje
func _physics_process(delta):
	if Input.is_action_pressed("player_hit"):
		if GameConfig.current_player != null:
			var dist = GameConfig.current_player.position.distance_to(position)
			if dist < 75:
				activate()
