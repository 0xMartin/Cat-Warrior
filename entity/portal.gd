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
		if GameConfig.current_player.position.distance_to(position) < 80:
			if $Timer.time_left == 0:
				if GameConfig.current_player != null:
					GameConfig.current_player.visible = false
				$Timer.start()
				$AnimationPlayer.play("New Anim")
				

func _on_Timer_timeout():
	GameConfig.next_level_request = true
