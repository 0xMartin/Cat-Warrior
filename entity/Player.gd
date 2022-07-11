extends KinematicBody2D

export var lives = 100
export var damage_shot = 5
export var damage_hit = 10

export var gravity = 1000
export var speed = 200
export var jump = 600
var move = Vector2()

func _physics_process(delta):
	# gravitace
	move.y += gravity * delta;
	
	# ovladani pohybu (jen pokud stoji na zemi)
	if is_on_floor():
		var key_down = false
		if Input.is_action_pressed("player_left"):
			move.x = -speed	
			key_down = true
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("walk")
		if Input.is_action_pressed("player_right"):
			move.x = speed	
			key_down = true
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("walk")
		if Input.is_action_pressed("player_jump"):
			move.y = -jump	
			key_down = true
		if not key_down:
			move.x = 0	
			$AnimatedSprite.play("idle")
		
	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))
