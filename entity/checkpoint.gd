extends Node2D

var activated = false

export var index = 0

var explosion = preload("res://entity/fx/explosion.tscn").instance()

# automaticky aktivuje spawnpoint (v save hrace nastavi jeho index)
func activate():
	if not activated:
		$AnimatedSprite.play("on")
		Sound.checkpoint()
		GameConfig.player_save.spawnpoint_index = max(GameConfig.player_save.spawnpoint_index, index)
		
		# efekt
		get_parent().add_child(explosion)
		explosion.init(position, Color.gray, 130, 300, 6, 0.3, 0.2)
	activated = true
	

# pokud je hrac dostatecne blizko a zasahne spawnpoint pak se aktivuje
func _physics_process(delta):
	if Input.is_action_pressed("player_hit"):
		if GameConfig.current_player != null:
			var dist = GameConfig.current_player.position.distance_to(position)
			if dist < 75:
				activate()
