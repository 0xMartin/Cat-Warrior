extends Node2D


export var time = 100

var value = 0
var last_v = 0
const speed = 3
var explosion = preload("res://entity/fx/explosion.tscn").instance()

func _physics_process(delta):
	# animace
	value += delta * speed
	var v = sin(value) * 8
	$AnimatedSprite.offset.y = v
	
	if last_v < v and v < 0:
		if v >= -0.2:
			value = 0
	last_v = v
	
	# aktivace sily
	if GameConfig.current_player != null:
		var dist = GameConfig.current_player.position.distance_to(position)
		if dist < 35:
			# exploze
			get_parent().add_child(explosion)
			explosion.init(position, Color.red, 120, 300, 5, 0.25, 0.1)
			# pridani boostu
			GameConfig.current_player.setDefenseBoost(time)
			Sound.boost()
			queue_free()

