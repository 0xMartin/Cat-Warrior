extends Node2D

var value = 0
var last_v = 0
export var speed = 3

func _physics_process(delta):
	# animace
	value += delta * speed
	var v = sin(value) * 3
	$AnimatedSprite.offset.y = v
	
	if last_v < v and v < 0:
		if v >= -0.2:
			value = 0
	last_v = v
	
	# pokud hrac vejde dovnitr
	if GameConfig.current_player != null:
		if GameConfig.current_player.position.distance_to(position) < 65:
			print("portal")	
