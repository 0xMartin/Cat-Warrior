extends Node2D


var efx = preload("res://entity/fx/explosion.tscn").instance()


func _physics_process(delta):
	if GameConfig.current_player != null:
		if GameConfig.current_player.position.distance_to(position) < 45:
			GameConfig.current_player.lives += 10
			get_parent().add_child(efx)
			efx.init(position, Color.red, 90, 200, 4, 0.2, 0.1)
			Sound.heartTake()
			queue_free()	
