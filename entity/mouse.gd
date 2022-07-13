extends KinematicBody2D


export var gravity = 1000
export var speed = 80


var move = Vector2()
var rng = RandomNumberGenerator.new()


# 0 - idle
# 1 - walk left
# 2 - walk right
# 3 - attack
# 4 - waiting
var state = 0

var wait = 0


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return
		
	# gravitace
	move.y += min(gravity * delta, 1600);
	
	# akce
	if is_on_floor():
		match state:
			0:
				move.x = 0
				if wait <= 0:
					rng.randomize()
					if not $RayCastLeft.is_colliding():
						# pujde doprava
						state = 2
						$AnimatedSprite.flip_h = false
					elif not $RayCastRight.is_colliding():
						# pujde doleva
						state = 1
						$AnimatedSprite.flip_h = true
					else:
						# nahodny vyber smeru
						if rng.randi() % 2 == 1:
							state = 1
							$AnimatedSprite.flip_h = true
						else:
							state = 2
							$AnimatedSprite.flip_h = false
					$AnimatedSprite.play("walk")
					wait = rng.randi_range (60, 300)
				wait -= 1
			1:
				move.x = -speed
				if not $RayCastLeft.is_colliding() or is_on_wall() or wait <= 0:
					state = 4	
				wait -= 1
			2:
				move.x = speed
				if not $RayCastRight.is_colliding() or is_on_wall() or wait <= 0:
					state = 4	
				wait -= 1
			3:
				pass
			4:
				move.x = 0
				state = 0
				$AnimatedSprite.play("idle")
				rng.randomize()
				wait = rng.randi_range (60, 300)
			
	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))
